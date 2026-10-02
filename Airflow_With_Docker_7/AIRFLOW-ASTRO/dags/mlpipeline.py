from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

# Define our task 1

def preprocess_data():
    # Code to preprocess data
    print("Preprocessing data...")

# Define our task 2
def train_model():
    # Code to train the model
    print("Training model...")

# Define our task 3
def evaluate_model():
    # Code to evaluate the model
    print("Evaluating model...")


# Define the DAG
with DAG(
    'ml_pipeline',
    start_date=datetime(2024, 1, 1),
    schedule='@weekly'
) as dag:

    # Define the tasks
    preprocess_task = PythonOperator(
        task_id='preprocess_data',
        python_callable=preprocess_data,
    )

    train_task = PythonOperator(
        task_id='train_model',
        python_callable=train_model,
    )

    evaluate_task = PythonOperator(
        task_id='evaluate_model',
        python_callable=evaluate_model,
    )

    # Set the task dependencies
    preprocess_task >> train_task >> evaluate_task
