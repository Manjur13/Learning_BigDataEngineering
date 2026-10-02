"""
Daily housekeeping DAG: compacts the many small Parquet files the streaming
job writes every minute into one clean daily summary table. Streaming jobs
that write on every micro-batch trigger produce a "small files" problem over
time -- this is the compaction job that keeps the historical table healthy.
"""
import os
from datetime import datetime

from airflow.decorators import dag, task

DATA_DIR = os.getenv("AQI_DATA_DIR", "data")


@dag(schedule="@daily", start_date=datetime(2026, 1, 1), catchup=False)
def aqi_daily_rollup():

    @task
    def compact_and_summarize():
        import pyspark.sql.functions as F
        from pyspark.sql import SparkSession

        agg_path = os.path.join(DATA_DIR, "aqi_aggregates")
        if not os.path.exists(agg_path):
            print(f"No aggregates found at {agg_path} yet; skipping rollup.")
            return

        spark = SparkSession.builder.appName("DailyRollup").getOrCreate()
        df = spark.read.parquet(agg_path)
        daily = df.groupBy("city").agg(
            F.avg("avg_pm25").alias("daily_avg_pm25"),
            F.max("peak_pm25").alias("daily_peak_pm25"),
        )
        daily.write.mode("overwrite").parquet(os.path.join(DATA_DIR, "aqi_daily_summary"))
        spark.stop()

    compact_and_summarize()


aqi_daily_rollup()
