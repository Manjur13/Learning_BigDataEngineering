CREATE DATABASE IF NOT EXISTS aqi;

CREATE TABLE IF NOT EXISTS aqi.aqi_history (
    `window` STRUCT<start: TIMESTAMP, end: TIMESTAMP>,
    city STRING,
    avg_pm25 DOUBLE,
    peak_pm25 DOUBLE
)
USING PARQUET
LOCATION '/Users/manjursmac/Documents/Learning_BigDataEngineering/Projects/Aqi_realtime_platform/data/aqi_aggregates';

SELECT
    city,
    `window`.start AS window_start,
    `window`.end AS window_end,
    ROUND(avg_pm25, 2) AS avg_pm25,
    peak_pm25
FROM aqi.aqi_history
ORDER BY window_end DESC
LIMIT 20;