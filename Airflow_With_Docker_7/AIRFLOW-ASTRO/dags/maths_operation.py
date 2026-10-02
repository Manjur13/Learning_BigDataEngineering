# "
# We will create a DAG that performs basic mathematical operations such as addition, subtraction, multiplication, and division. Each operation will be represented as a separate task in the DAG, and we will use Airflow's PythonOperator to execute these tasks.

# Task 1 : start with an intial number 10
# Task 2 :  Add 5 to the initial number
# Task 3 :  Multiply the result of 2
# Task 4 : Subtract 3 from the result of Task 2
# Task 5: Compute the square of the result 

# "

from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

# Define our task 1
def initial_number():
    # Start with an initial number 10
    initial_value = 10
    print(f"Initial number: {initial_value}")
    return initial_value  

# Define our task 2
def add_five(ti):
    # Add 5 to the initial number
    initial_value = ti.xcom_pull(task_ids='initial_number')
    result = initial_value + 5
    print(f"After adding 5: {result}")
    return result

# Define our task 3
def multiply_by_two(ti): 
    # Multiply the result of Task 2 by 2
    result_from_addition = ti.xcom_pull(task_ids='add_five')
    result = result_from_addition * 2
    print(f"After multiplying by 2: {result}")
    return result

# Define our task 4
def subtract_three(ti):
    # Subtract 3 from the result of Task 3
    result_from_multiplication = ti.xcom_pull(task_ids='multiply_by_two')
    result = result_from_multiplication - 3
    print(f"After subtracting 3: {result}")
    return result

# Define our task 5
def compute_square(ti):
    # Compute the square of the result from Task 4
    result_from_subtraction = ti.xcom_pull(task_ids='subtract_three')
    result = result_from_subtraction ** 2
    print(f"Square of the result: {result}")
    return result

# Define the DAG
with DAG(
    'math_operations',
    start_date=datetime(2024, 1, 1),
    schedule='@once',
    catchup=False # catchup means
) as dag:

    # Define the tasks
    initial_task = PythonOperator(
        task_id='initial_number',
        python_callable=initial_number,
    )

    add_task = PythonOperator(
        task_id='add_five',
        python_callable=add_five,
    )

    multiply_task = PythonOperator(
        task_id='multiply_by_two',
        python_callable=multiply_by_two,
    )

    subtract_task = PythonOperator(
        task_id='subtract_three',
        python_callable=subtract_three,
    )

    square_task = PythonOperator(
        task_id='compute_square',
        python_callable=compute_square,
    )

    # Set the task dependencies
    initial_task >> add_task >> multiply_task >> subtract_task >> square_task