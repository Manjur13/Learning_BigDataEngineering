"""
Pulls live AQI sensor readings from the OpenAQ v3 API and publishes them to Kafka.

OpenAQ v3 has no "city" search param on /locations (the common recipe for this
pipeline that filters /locations by city= is wrong against the real API) --
locations are discovered by coordinates + radius instead, then cached so we
don't re-run discovery every poll cycle. Also, OpenAQ v3 requires an API key
(X-API-Key) on every request, not just for higher rate limits.
"""
import json
import os
import time

import requests
from dotenv import load_dotenv
from kafka import KafkaProducer

load_dotenv()

API_KEY = os.getenv("OPENAQ_API_KEY", "")
BASE_URL = "https://api.openaq.org/v3"
BOOTSTRAP_SERVERS = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
TOPIC = os.getenv("KAFKA_TOPIC", "aqi-readings")

POLL_INTERVAL_SECONDS = int(os.getenv("POLL_INTERVAL_SECONDS", "60"))
LOCATIONS_PER_CITY = int(os.getenv("LOCATIONS_PER_CITY", "3"))
DISCOVERY_RADIUS_METERS = 25000  # OpenAQ v3 caps radius at 25km
TARGET_PARAMETERS = {"pm25", "pm10", "no2", "o3", "so2", "co"}

# city -> (lat, lon). OpenAQ v3 has no free-text city filter, so we discover
# stations near each city's center instead.
CITIES = {
    "Delhi": (28.7041, 77.1025),
    "Mumbai": (19.0760, 72.8777),
    "Ahmedabad": (23.0225, 72.5714),
    "Bengaluru": (12.9716, 77.5946),
    "Kolkata": (22.5726, 88.3639),
}

HEADERS = {"X-API-Key": API_KEY} if API_KEY else {}

producer = KafkaProducer(
    bootstrap_servers=BOOTSTRAP_SERVERS,
    value_serializer=lambda v: json.dumps(v).encode("utf-8"),
)


def discover_locations(city, lat, lon):
    """Find monitoring stations near a city and cache their sensor->parameter map."""
    url = f"{BASE_URL}/locations"
    params = {
        "coordinates": f"{lat},{lon}",
        "radius": DISCOVERY_RADIUS_METERS,
        "limit": LOCATIONS_PER_CITY,
    }
    try:
        resp = requests.get(url, headers=HEADERS, params=params, timeout=15)
    except requests.RequestException as exc:
        print(f"[discover] {city}: request failed ({exc})")
        return {}

    if resp.status_code != 200:
        print(f"[discover] {city}: HTTP {resp.status_code} - {resp.text[:200]}")
        return {}

    locations = {}
    for loc in resp.json().get("results", []):
        loc_id = loc.get("id")
        sensors = {
            s["id"]: s.get("parameter", {}).get("name")
            for s in loc.get("sensors", [])
            if s.get("parameter", {}).get("name") in TARGET_PARAMETERS
        }
        if not sensors:
            continue
        coords = loc.get("coordinates", {}) or {}
        locations[loc_id] = {
            "city": city,
            "location_name": loc.get("name"),
            "lat": coords.get("latitude"),
            "lon": coords.get("longitude"),
            "sensors": sensors,
        }
    print(f"[discover] {city}: cached {len(locations)} station(s)")
    return locations


def fetch_latest(location_id, meta):
    """Pull the latest reading per sensor for one station and emit Kafka events."""
    url = f"{BASE_URL}/locations/{location_id}/latest"
    try:
        resp = requests.get(url, headers=HEADERS, timeout=15)
    except requests.RequestException as exc:
        print(f"[latest] location {location_id}: request failed ({exc})")
        return 0

    if resp.status_code == 429:
        print(f"[latest] location {location_id}: rate limited, backing off")
        time.sleep(5)
        return 0
    if resp.status_code != 200:
        print(f"[latest] location {location_id}: HTTP {resp.status_code}")
        return 0

    sent = 0
    for row in resp.json().get("results", []):
        sensor_id = row.get("sensorsId")
        parameter = meta["sensors"].get(sensor_id)
        if parameter is None:
            continue
        event = {
            "city": meta["city"],
            "location_id": location_id,
            "location_name": meta["location_name"],
            "lat": meta["lat"],
            "lon": meta["lon"],
            "parameter": parameter,
            "value": row.get("value"),
            "timestamp": time.time(),
        }
        producer.send(TOPIC, value=event)
        sent += 1
    return sent


def run():
    print(f"Connecting to Kafka at {BOOTSTRAP_SERVERS}, topic '{TOPIC}'")
    if not API_KEY:
        print("WARNING: OPENAQ_API_KEY is not set. OpenAQ v3 requires an API "
              "key on every request; requests will likely fail with 401. "
              "Get a free key at openaq.org and put it in .env")

    station_cache = {}
    for city, (lat, lon) in CITIES.items():
        station_cache.update(discover_locations(city, lat, lon))

    if not station_cache:
        print("No stations discovered - check your API key and network, then retry.")

    while True:
        total_sent = 0
        for location_id, meta in station_cache.items():
            total_sent += fetch_latest(location_id, meta)
        producer.flush()
        print(f"Cycle complete: sent {total_sent} reading(s) across "
              f"{len(station_cache)} station(s)")
        time.sleep(POLL_INTERVAL_SECONDS)


if __name__ == "__main__":
    run()
