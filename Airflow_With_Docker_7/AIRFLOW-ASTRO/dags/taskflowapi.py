from airflow import DAG
from airflow.operators.python import PythonOperator 
from airflow.decorators import task
from datetime import datetime

# define the DAG

with DAG(
    dag_id='math_sequence_dag_with_taskflow',
    start_date=datetime(2024, 1, 1),
    schedule='@once',
    catchup=False,
) as dag:

    @task
    def initial_number():
        # Start with an initial number 10
        initial_value = 10
        print(f"Initial number: {initial_value}")
        return initial_value

    @task
    def add_five(initial_value):
        # Add 5 to the initial number
        result = initial_value + 5
        print(f"After adding 5: {result}")
        return result

    @task
    def multiply_by_two(result_from_addition):
        # Multiply the result of Task 2 by 2
        result = result_from_addition * 2
        print(f"After multiplying by 2: {result}")
        return result

    @task
    def subtract_three(result_from_multiplication):
        # Subtract 3 from the result of Task 3
        result = result_from_multiplication - 3
        print(f"After subtracting 3: {result}")
        return result

    @task
    def compute_square(result_from_subtraction):
        # Compute the square of the result from Task 4
        result = result_from_subtraction ** 2
        print(f"Square of the result: {result}")
        return result

    # Define the task dependencies using TaskFlow API
    initial_value = initial_number()
    added_value = add_five(initial_value)
    multiplied_value = multiply_by_two(added_value)
    subtracted_value = subtract_three(multiplied_value)
    final_result = compute_square(subtracted_value)


