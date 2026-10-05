# Big Data Engineering Portfolio

An applied portfolio focused on building data workflows from source to usable output. The work spans batch and streaming ingestion, distributed processing, orchestration, and analytical serving with Python, SQL, Java, Hadoop, Spark, Kafka, Airflow, and cloud platforms.

The repository combines end-to-end projects with focused notebooks and exercises. Each project includes its architecture, technologies, and environment-specific instructions.

## Selected Projects

| Project | Engineering work | Guide |
| --- | --- | --- |
| Real-Time AQI Monitoring Platform | Builds a streaming pipeline that ingests OpenAQ readings through Kafka, computes rolling aggregates and threshold alerts with Spark Structured Streaming, persists results, and serves live and historical views in Streamlit. An Airflow DAG creates daily rollups. | [Project README](Projects/Aqi_realtime_platform/README.md) |
| NASA APOD ETL Pipeline | Orchestrates a scheduled API-to-PostgreSQL workflow with Airflow, including extraction, transformation, table creation, and database loading. | [Project README](Projects/Nasa_API_AirFlow_Project_without_astronommer/ETL_PIPLELINE_NASA_API/README.md) |
| Brazilian E-Commerce Data Engineering | Develops a modular PySpark workflow for data profiling, cleaning, multi-table integration, analytical aggregation, performance experiments, and serving to Parquet and cloud storage. | [Project README](Projects/Project_Brazilian_E-Commerce_by_Olist_with_GCP/README.md) |
| Wikipedia Trending Articles | Implements Java MapReduce jobs that aggregate Wikimedia page views and rank articles by comparing target-day traffic with a seven-day baseline. | [Project README](Projects/Wikipedia_Trending_Articles_Pipeline_with_Hadoop_MapReduce_on_GCP/README.md) |

## Engineering Focus

- **Data pipelines:** API and event ingestion, transformation, validation, aggregation, and database or file-based loading.
- **Distributed processing:** Hadoop MapReduce and Spark/PySpark batch and streaming workloads.
- **Orchestration:** Airflow DAGs, task dependencies, scheduled execution, and database hooks.
- **Analytics and serving:** SQL, Parquet, PostgreSQL, dashboards, and cloud storage patterns.
- **Performance concepts:** Spark partitioning, joins, caching, shuffle configuration, and adaptive execution.

## Learning Areas

| Area | Repository contents |
| --- | --- |
| [Python](Python_2/) | Beginner through advanced language topics, data analysis with NumPy and pandas, database access, and exercises in Jupyter notebooks. |
| [SQL](SQL_1/) | Query exercises, tutorial material, and a record of completed topics. |
| [Hadoop MapReduce](MapReduce_3/) | Java word-count examples covering jobs with zero, one, and multiple reducers, plus command notes and a BigLog exercise. |
| [Apache Spark](Spark_4/) | Low-level and higher-level Spark API exercises and caching examples. |
| [Apache Hive](Hive_5/) | Hive command reference. |
| [Apache Kafka](Kafka_6/) | Producer and consumer notebooks using Confluent Kafka. |
| [Apache Airflow](Airflow_With_Docker_7/AIRFLOW-ASTRO/) | An Astronomer/Airflow project scaffold for local development with Docker. |

## Suggested Path

1. Start with the Python and SQL exercises to build programming and data-querying foundations.
2. Explore Hive, MapReduce, and Spark to learn batch processing and distributed data concepts.
3. Work through Kafka and Airflow for streaming and orchestration patterns.
4. Choose a project above and follow its README for the architecture, prerequisites, and run steps.

## Technologies

Python, SQL, Java, Jupyter, NumPy, pandas, Hadoop MapReduce, HDFS, Hive, Apache Spark, PySpark, Kafka, Apache Airflow, PostgreSQL, Docker, Streamlit, Google Cloud Dataproc, and Google Cloud Storage.

## Getting Started

There is no single environment setup for the entire repository. Many lessons are notebooks or reference material; project requirements vary and may include Docker, Java, Spark/Hadoop, cloud credentials, API keys, or external datasets. Start with the README in the project you want to run and use its instructions to configure that project's environment.

Some examples depend on services or data that are not bundled here. Check each project guide for dataset sources, credentials, environment-specific paths, and known limitations before running it.
