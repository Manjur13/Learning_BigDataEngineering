"""
Spark Structured Streaming consumer: reads raw AQI readings from Kafka,
computes rolling PM2.5 averages per city, and writes two sinks:
  1. Parquet aggregates (the "historical" table the dashboard/Hive query from)
  2. JSON alerts for any 5-minute window whose peak PM2.5 crosses 150 (unhealthy)

Note on schema: the producer emits one record per (station, pollutant) pair
as {parameter, value}, not a flat "pm25" column -- that's the actual shape of
OpenAQ v3's /locations/{id}/latest response. We filter to parameter == "pm25"
right after parsing instead of assuming the topic only ever carries PM2.5.
"""
import os

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json, max as spark_max, avg, window
from pyspark.sql.types import DoubleType, StringType, StructType, TimestampType

KAFKA_BOOTSTRAP_SERVERS = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
KAFKA_TOPIC = os.getenv("KAFKA_TOPIC", "aqi-readings")
DATA_DIR = os.getenv("AQI_DATA_DIR", "data")
ALERT_THRESHOLD_PM25 = float(os.getenv("ALERT_THRESHOLD_PM25", "150"))

spark = SparkSession.builder \
    .appName("AQIStreamProcessor") \
    .config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.3") \
    .config("spark.sql.shuffle.partitions", "4") \
    .getOrCreate()
spark.sparkContext.setLogLevel("WARN")

schema = StructType() \
    .add("city", StringType()) \
    .add("location_id", StringType()) \
    .add("location_name", StringType()) \
    .add("lat", DoubleType()) \
    .add("lon", DoubleType()) \
    .add("parameter", StringType()) \
    .add("value", DoubleType()) \
    .add("timestamp", DoubleType())

raw = spark.readStream.format("kafka") \
    .option("kafka.bootstrap.servers", KAFKA_BOOTSTRAP_SERVERS) \
    .option("subscribe", KAFKA_TOPIC) \
    .option("startingOffsets", "latest") \
    .load()

parsed = raw.selectExpr("CAST(value AS STRING) as json") \
    .select(from_json(col("json"), schema).alias("data")).select("data.*") \
    .withColumn("event_time", col("timestamp").cast(TimestampType())) \
    .filter(col("parameter") == "pm25") \
    .withColumnRenamed("value", "pm25")

# Rolling 5-minute average AQI per city, computed every 1 minute
windowed = parsed \
    .withWatermark("event_time", "10 minutes") \
    .groupBy(window(col("event_time"), "5 minutes", "1 minute"), col("city")) \
    .agg(avg("pm25").alias("avg_pm25"), spark_max("pm25").alias("peak_pm25"))

# Sink 1: write aggregates to Parquet (the "historical" table Streamlit/Hive read).
# File sinks only support "append" output mode -- "update" raises
# AnalysisException here. Append means a window's row is only written once the
# watermark closes it, so aggregates land ~10 minutes after the window ends.
agg_query = windowed.writeStream \
    .outputMode("append") \
    .format("parquet") \
    .option("path", f"{DATA_DIR}/aqi_aggregates") \
    .option("checkpointLocation", f"{DATA_DIR}/checkpoints/agg") \
    .trigger(processingTime="1 minute") \
    .start()


# Sink 2: alerting -- flag any reading crossing an unhealthy threshold
def alert_batch(df, epoch_id):
    alerts = df.filter(col("peak_pm25") > ALERT_THRESHOLD_PM25)
    count = alerts.count()
    if count > 0:
        alerts.write.mode("append").json(f"{DATA_DIR}/alerts")
        print(f"[ALERT] {count} unhealthy AQI reading(s) at batch {epoch_id}")


alert_query = windowed.writeStream \
    .outputMode("update") \
    .foreachBatch(alert_batch) \
    .trigger(processingTime="1 minute") \
    .start()

spark.streams.awaitAnyTermination()
