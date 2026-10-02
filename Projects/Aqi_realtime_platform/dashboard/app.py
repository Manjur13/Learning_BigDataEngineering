"""
Streamlit dashboard: a Live tab (latest rolling PM2.5 window per city on a
map) and a Historical tab (daily summary trend, fed by the Airflow rollup).

Note: the Spark aggregation only groups by (window, city) -- it doesn't carry
station lat/lon through the groupBy, so there's nothing to plot a map with
straight out of data/aqi_aggregates. We join city -> centroid coordinates
here instead of threading lat/lon through the streaming aggregation, since
averaging station coordinates per city wouldn't mean anything useful anyway.
"""
import os

import pandas as pd
import pydeck as pdk
import streamlit as st
from streamlit_autorefresh import st_autorefresh

DATA_DIR = os.getenv("AQI_DATA_DIR", "data")
AGG_PATH = os.path.join(DATA_DIR, "aqi_aggregates")
DAILY_PATH = os.path.join(DATA_DIR, "aqi_daily_summary")

# Same city centroids the producer uses for OpenAQ station discovery.
CITY_COORDS = {
    "Delhi": (28.7041, 77.1025),
    "Mumbai": (19.0760, 72.8777),
    "Ahmedabad": (23.0225, 72.5714),
    "Bengaluru": (12.9716, 77.5946),
    "Kolkata": (22.5726, 88.3639),
}

st.set_page_config(page_title="AQI Live Monitor", layout="wide")
st.title("Real-Time AQI Monitoring Platform")

tab1, tab2 = st.tabs(["Live", "Historical"])

with tab1:
    st_autorefresh(interval=30_000, key="live_refresh")

    if not os.path.exists(AGG_PATH):
        st.info(
            "No streaming aggregates yet. Make sure the producer and the "
            "Spark consumer are both running -- data/aqi_aggregates is "
            "created by the consumer's first completed trigger."
        )
    else:
        df = pd.read_parquet(AGG_PATH)
        if df.empty:
            st.info("Aggregates table exists but is empty -- waiting for the first window to close.")
        else:
            df["window_end"] = df["window"].apply(lambda w: w["end"])
            latest = (
                df.sort_values("window_end")
                .groupby("city", as_index=False)
                .tail(1)
                .sort_values("avg_pm25", ascending=False)
            )
            latest["lat"] = latest["city"].map(lambda c: CITY_COORDS.get(c, (None, None))[0])
            latest["lon"] = latest["city"].map(lambda c: CITY_COORDS.get(c, (None, None))[1])

            st.dataframe(latest[["city", "avg_pm25", "peak_pm25", "window_end"]])

            map_df = latest.dropna(subset=["lat", "lon"])
            if not map_df.empty:
                st.pydeck_chart(pdk.Deck(
                    map_style=None,
                    initial_view_state=pdk.ViewState(latitude=22.5, longitude=79, zoom=3.5),
                    layers=[pdk.Layer(
                        "ScatterplotLayer",
                        data=map_df,
                        get_position="[lon, lat]",
                        get_radius=20000,
                        get_fill_color="[255, 140 - avg_pm25, 0, 160]",
                    )],
                ))

with tab2:
    if not os.path.exists(DAILY_PATH):
        st.info(
            "No daily summary yet. Trigger the Airflow DAG "
            "`aqi_daily_rollup` (or run it manually) after the streaming "
            "job has produced at least one day of aggregates."
        )
    else:
        hist = pd.read_parquet(DAILY_PATH)
        if hist.empty:
            st.info("Daily summary table exists but is empty.")
        else:
            st.dataframe(hist)
            st.bar_chart(hist.set_index("city")["daily_avg_pm25"])
