from airflow import DAG
from airflow.providers.http.operators.http import HttpOperator
from airflow.decorators import task
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime
import json


#define the DAG
with DAG(
    dag_id='nasa_apod_postgres',
    start_date=datetime(2024, 1, 1),
    schedule='@daily',
    catchup=False,
) as dag:

# Step 1: Create the table if it doesn't exist

    @task
    def create_table():
        # Initialize the Postgres hook
        postgres_hook = PostgresHook(postgres_conn_id='postgres_default')

        # SQL query to create the table
        create_table_query = """
        CREATE TABLE IF NOT EXISTS nasa_apod ( 
            id SERIAL PRIMARY KEY,
            title varchar(255),
            explanation TEXT,
            url TEXT,
            date DATE,
            media_type VARCHAR(50)
        );
        """

        # Execute the query
        postgres_hook.run(create_table_query)

    #Step 2: Extract data from the NASA APOD API  - Astronomy Picture of the Day
    # api_key is pulled from the "nasa_apod_api" Airflow Connection's extra field, not hardcoded here

    extract_apod_data = HttpOperator(
        task_id="extract_apod_data",
        http_conn_id="nasa_apod_api",
        endpoint="planetary/apod",
        method="GET",
        data={
            "api_key": "{{ conn.nasa_apod_api.extra_dejson.api_key }}"
        },
        response_filter=lambda response: response.json(),
    )

    #Step 3: Transform the data to match the table schema
    @task
    def transform_data(apod_data):
        # Transform the data to match the table schema
        transformed_data = {
            'title': apod_data.get('title', ''),
            'explanation': apod_data.get('explanation', ''),
            'url': apod_data.get('url', ''),
            'date': apod_data.get('date', ''),
            'media_type': apod_data.get('media_type', '')
        }
        return transformed_data


    #Step 4: Load the data into the Postgres database

    @task
    def load_data(transformed_data):
        # Initialize the Postgres hook
        postgres_hook = PostgresHook(postgres_conn_id='postgres_default')

        # SQL query to insert the data into the table
        insert_query = """
        INSERT INTO nasa_apod (title, explanation, url, date, media_type)
        VALUES (%s, %s, %s, %s, %s);
        """

        # Execute the query with the transformed data
        postgres_hook.run(insert_query, parameters=(
            transformed_data['title'],
            transformed_data['explanation'],
            transformed_data['url'],
            transformed_data['date'],
            transformed_data['media_type']
        ))

#Step 5: Verify the data DBViewer 


#Step 6: Define the tasks and their dependencies
#extract
create_table() >> extract_apod_data # ensure the table is created before extracting data
api_response = extract_apod_data.output
# transform
transformed_data = transform_data(api_response)
# load
transformed_data >> load_data(transformed_data) # ensure the data is transformed before loading into the database