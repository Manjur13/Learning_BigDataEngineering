# Real-Time AQI Monitoring Platform

Live air-quality readings flow through Kafka, get aggregated by Spark
Structured Streaming into rolling PM2.5 averages and threshold alerts, land
in a Parquet table, and surface on a Streamlit dashboard (live map +
historical trend). An Airflow DAG compacts the streaming output into a daily
summary table.

## Architecture

```
OpenAQ v3 API
     │  (poll every 60s, per-station PM2.5/PM10/NO2/... readings)
     ▼
producer/produce_aqi.py  ──publish──▶  Kafka topic: aqi-readings
                                              │
                                              ▼
                              consumer/stream_consumer.py
                              (Spark Structured Streaming)
                              5-min rolling window, 1-min trigger
                                    │                  │
                        ┌───────────┘                  └───────────┐
                        ▼                                          ▼
          data/aqi_aggregates/ (Parquet)                data/alerts/ (JSON)
          "historical" table                             peak PM2.5 > 150
                        │
                        ▼
          airflow_dags/aqi_daily_rollup.py  ──▶  data/aqi_daily_summary/
          (daily @ midnight, compacts small files)
                        │
                        ▼
          dashboard/app.py (Streamlit: Live map tab + Historical tab)
```

## Setup

```bash
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

PySpark needs a JDK. On macOS:

```bash
brew install openjdk@17
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="$JAVA_HOME/bin:$PATH"
```

Copy `.env.example` to `.env` and set `OPENAQ_API_KEY` (free, from
[openaq.org](https://explore.openaq.org/register)) -- OpenAQ v3 requires an
API key on every request, including basic reads.

```bash
cp .env.example .env   # then edit in your API key
```

## Run everything

```bash
./run_all.sh
```

This starts Kafka (Docker Compose), creates the `aqi-readings` topic, runs
the producer and the Spark consumer in the background, and launches the
Streamlit dashboard in the foreground.

Or step by step:

```bash
docker compose up -d
docker exec <kafka-container> kafka-topics --create --if-not-exists \
  --topic aqi-readings --bootstrap-server localhost:9092 \
  --partitions 3 --replication-factor 1

source venv/bin/activate
python producer/produce_aqi.py        # terminal 1
python consumer/stream_consumer.py     # terminal 2
streamlit run dashboard/app.py         # terminal 3
```

Check `http://localhost:8080` (Kafka UI) to confirm messages are landing on
`aqi-readings` before worrying about anything downstream.

## Historical queries (Hive-style)

Once `data/aqi_aggregates/` has some data, register it as an external table
for SQL-style queries over the same Parquet the streaming job writes:

```sql
CREATE EXTERNAL TABLE aqi_history (
  window STRUCT<start: TIMESTAMP, end: TIMESTAMP>,
  city STRING,
  avg_pm25 DOUBLE,
  peak_pm25 DOUBLE
)
STORED AS PARQUET
LOCATION 'data/aqi_aggregates';
```

## Daily rollup DAG

`airflow_dags/aqi_daily_rollup.py` is a TaskFlow DAG that runs `@daily`,
reads `data/aqi_aggregates/`, and writes one compacted row per city to
`data/aqi_daily_summary/`. Point your `AIRFLOW_HOME`'s dags folder at
`airflow_dags/` (or symlink it in) to pick it up.

## What broke / design notes

- **OpenAQ v3 has no `city=` filter on `/locations`.** The common recipe for
  this kind of pipeline assumes it does; the real API only supports
  `coordinates` + `radius` (capped at 25km) or `bbox`/`iso`. The producer
  discovers stations by city centroid + radius instead and caches the
  sensor→parameter map per station at startup, so each poll cycle only hits
  `/locations/{id}/latest` rather than re-running discovery.
- **OpenAQ v3 requires an API key on every call**, not just for higher rate
  limits -- a missing key means 401s, not degraded service.
- **File sinks only support `append` output mode in Structured Streaming.**
  Writing the windowed aggregation to Parquet with `outputMode("update")`
  raises `AnalysisException`. The fix is `append`, which means a window's
  row is only emitted once the watermark closes it -- aggregates lag their
  window's end by roughly the watermark delay (10 minutes here). Tightening
  the watermark trades off against dropping genuinely late-arriving readings.
- **The windowed aggregation has no lat/lon.** Grouping by `(window, city)`
  drops station coordinates, and averaging multiple stations' coordinates
  per city wouldn't mean anything useful anyway. The dashboard joins city
  names back to fixed centroids for the map instead of threading coordinates
  through the Spark job.
- **The daily rollup overwrites, so there's no multi-day trend** yet --
  `aqi_daily_summary` always holds one row per city for the most recent
  rollup. Making the Historical tab show a real trend would mean writing
  `aqi_daily_summary` partitioned by date and appending instead of
  overwriting.
- **Full stack runs locally via `docker compose up`** -- the Kafka + Spark
  combination won't run on Streamlit Community Cloud's free tier, so a demo
  GIF of the live dashboard stands in for a hosted deployment.
