# Brazilian E-Commerce Data Engineering with PySpark and Google Cloud

An end-to-end learning project exploring how to process the Brazilian Olist e-commerce dataset with Apache Spark. The notebooks take the data from CSV ingestion and quality checks through cleaning, integration, performance tuning, and storage for downstream analysis.

## Project Overview

The project is organized as five modules that follow a typical batch data engineering workflow:

```text
Olist CSV tables
      |  Ingest and inspect
      v
HDFS / Dataproc + PySpark
      |  Clean, transform, join, aggregate
      v
Integrated order data
      |  Store and serve
      +--> Parquet on HDFS
      +--> Parquet on Google Cloud Storage
      +--> Spark/Hive table or CSV
```

The notebooks are designed around a Google Cloud Dataproc Spark cluster, with HDFS used for distributed input and intermediate data. They include Spark configuration experiments for parallelism, shuffle partitions, adaptive query execution, caching, and join strategies.

## What I Built

| Module | Work covered |
| --- | --- |
| [Data ingestion and exploration](Code/IPYNB%20FILE/module_1_Data%20Ingestion_and_Exploration.ipynb) | Read the nine CSV tables with PySpark, inspect schemas and row counts, check nulls and duplicate customer IDs, and explore order status, customer state, payment type, product sales, and delivery time. |
| [Data cleaning and transformation](Code/IPYNB%20FILE/module_2_Data_Cleaning_and_Transformation%20(1).ipynb) | Handle missing values, test mean/median imputation for payment values, standardize selected date/payment fields, cast ZIP prefixes, remove duplicate customers, join order details, and derive product size categories. |
| [Integration and aggregation](Code/IPYNB%20FILE/module_3_Data_Integration_and_Aggregation.ipynb) | Join orders with items, products, sellers, customers, geolocation, reviews, and payments; use broadcast joins and caching; calculate seller revenue, customer order counts and spending, review metrics, product popularity, and seller-product rankings. |
| [Performance optimization](Code/IPYNB%20FILE/module_4%20_Property_Optmization.ipynb) | Explore Spark executor and driver settings, shuffle/partition tuning, adaptive execution, broadcast joins, sort/merge and repartitioned joins, and skew-handling concepts. |
| [Data serving](Code/IPYNB%20FILE/module_5_Data_Serving.ipynb) | Read processed Parquet and demonstrate writing data as Parquet to HDFS and Google Cloud Storage, registering a Spark table, and exporting CSV. |

## Data

The `Dataset/` folder contains the Olist public dataset as nine CSV files:

- Customers, geolocation, orders, order items, payments, and reviews
- Products, sellers, and product-category name translations

Source: [Brazilian E-Commerce Public Dataset by Olist on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). The dataset contains commercial transaction and customer-experience records; consult the source page for its terms and details.

## Tools and Technologies

- Python and PySpark
- Apache Spark DataFrames and Spark SQL
- Google Cloud Dataproc (target execution environment)
- HDFS and Google Cloud Storage
- Parquet and CSV
- Jupyter notebooks

## Repository Layout

```text
Project_Brazilian_E-Commerce_by_Olist_with_GCP/
├── Code/
│   ├── IPYNB FILE/   # Five module notebooks
│   └── PDF FILE/     # Module notes/reference PDFs
├── Dataset/          # Nine Olist CSV tables
└── README.md
```

## Screenshots and Output Images

Store project screenshots and other visual results in an `Output/` folder at the project root, alongside `README.md`. Link each image from this README with a relative path, for example `![Spark result](Output/spark_result.png)`. Data products created by the notebooks are written to the configured HDFS or Google Cloud Storage paths instead; update those paths in Module 5 for your environment.

## Running the Notebooks

The notebooks were authored for a Spark environment with access to HDFS and, for the serving examples, Google Cloud Storage. They are not standalone local scripts.

1. Create or select a Spark environment. For the intended cloud setup, provision a Google Cloud Dataproc cluster and configure credentials and permissions for the cluster and target GCS bucket.
2. Upload the CSV files from `Dataset/` to the HDFS directory expected by the notebook, or update the `hdfs_path` values in the notebooks to match your storage location.
3. Open the notebooks under `Code/IPYNB FILE/` and run the modules in order. Modules 4 and 5 expect processed Parquet data from an earlier step.
4. Update the output paths in Module 5 before writing to HDFS or GCS. The example GCS path in the notebook is environment-specific.

The notebooks use PySpark and Hadoop filesystem commands. A compatible Spark/Hadoop installation and access to a running Spark session are required; the project does not currently include an automated environment setup or dependency lock file.

## Notes and Limitations

- This is a hands-on, modular learning project rather than a packaged production pipeline. Cluster deployment, credentials, and storage locations must be supplied by the person running it.
- HDFS paths differ between modules, so align them with your environment before running the full workflow.
- Some notebook sections are exploratory examples, and the notebooks have not been verified here as a clean, end-to-end run. Review cells and adapt them to your Spark version and data layout.
- The optimization notebook demonstrates approaches and configuration ideas; it does not include controlled before/after benchmark results.

## Skills Demonstrated

Distributed data ingestion, schema and data-quality inspection, null handling and deduplication, PySpark transformations, multi-table joins, analytical aggregations and window functions, Spark performance configuration, and data persistence for downstream use.