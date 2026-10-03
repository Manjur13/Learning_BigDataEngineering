# Learning Big Data Engineering

Course notes, exercises, and projects covering Python, SQL, Hadoop, Spark,
Kafka, Hive, Airflow, and cloud data engineering.

## Project Output Images

Keep screenshots and other project images in an `Output/` directory inside
the project they belong to. Current examples:

- AQI real-time platform: [Streamlit dashboard](Projects/Aqi_realtime_platform/Output/streamlit_output.png) and [Hive output](Projects/Aqi_realtime_platform/Output/hive_output.png).
- Wikipedia trending pipeline: [final output](Projects/Wikipedia_Trending_Articles_Pipeline_with_Hadoop_MapReduce_on_GCP/Output/final_output.png), [daily top 20](Projects/Wikipedia_Trending_Articles_Pipeline_with_Hadoop_MapReduce_on_GCP/Output/output_per_day_top20_views.png), and [memory usage](Projects/Wikipedia_Trending_Articles_Pipeline_with_Hadoop_MapReduce_on_GCP/Output/memory_usages.png).

In a project's README, link to an image relative to that README. For example:

```markdown
![Dashboard screenshot](Output/dashboard.png)
```

Keep generated data and runtime artifacts in the relevant project's own output
or data directory; check its `.gitignore` before expecting those files to be
included in GitHub.