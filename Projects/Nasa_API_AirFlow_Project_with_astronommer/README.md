# NASA APOD ETL with Astro and Amazon RDS

This project demonstrates a cloud ETL pipeline: Apache Airflow running on
Astronomer (Astro) retrieves NASA's Astronomy Picture of the Day (APOD), stores
it in Amazon RDS for PostgreSQL, and lets you verify the saved records with
DBeaver.

## Architecture

```text
NASA APOD API
     |
     v
Astro Cloud Airflow DAG
  create_table -> extract -> transform -> load
                                  |
                                  v
                     Amazon RDS PostgreSQL
                                  |
                                  v
                         DBeaver verification
```

Airflow connects to both the NASA API and RDS using Airflow Connections. Keep
credentials in Astro/Airflow Connections; do not commit API keys, passwords,
or private connection strings to this repository.

## Prerequisites

- An Astronomer account and the Astro CLI.
- An AWS account with permission to create an RDS database and configure its
  VPC and security groups.
- DBeaver installed on your computer.
- A NASA API key from [api.nasa.gov](https://api.nasa.gov/). NASA's `DEMO_KEY`
  can be used for a quick test, but it has lower usage limits.

Cloud database and Airflow resources can incur charges. Choose small resources
for a demo and delete them when they are no longer needed.

## 1. Initialize the Astro project

Open a terminal in this project directory and initialize the Airflow project:

```bash
cd Projects/Nasa_API_AirFlow_Project_with_astronommer
astro dev init
```

The command creates the standard Astro project folders, including `dags/`,
`Dockerfile`, and `requirements.txt`. Put the DAG shown below in
`dags/nasa_apod_etl.py`.

Check that the DAG parses locally:

```bash
astro dev parse
```

If the Astro Runtime selected by the project does not already include these
providers, add them to `requirements.txt` and rebuild/redeploy:

```text
apache-airflow-providers-http
apache-airflow-providers-postgres
```

## 2. Create the PostgreSQL database in Amazon RDS

In the AWS Console:

1. Open **RDS → Databases → Create database** and select **PostgreSQL**.
2. For a learning project, select a small development instance, set a database
   name such as `nasa_apod`, and create a dedicated database user and password.
   Do not reuse your AWS account password.
3. Place the instance in a VPC and subnets that can be reached from Astro.
   Prefer private network connectivity supported by your Astro plan and AWS
   setup. If you use a publicly accessible RDS endpoint for a temporary demo,
   restrict inbound access to the Astro deployment's documented outbound
   addresses only.
4. In the RDS security group, add an inbound PostgreSQL rule on port `5432`
   from the required Astro network/address range. **Do not allow `0.0.0.0/0`.**
5. For DBeaver, add a separate inbound rule for your current public IP address
   (also on port `5432`). Remove this rule when you no longer need it.
6. Wait until the RDS status is **Available** and copy its endpoint, for
   example `your-db.xxxxx.region.rds.amazonaws.com`. The endpoint is a hostname,
   not a URL: do not include `https://` or `:5432`.

Astro and AWS networking depends on the Astro deployment type, AWS region, and
account setup. Confirm the supported private connectivity or exact outbound
addresses for your deployment before configuring the RDS security group.

## 3. Configure connections in Astro Airflow

Deploy the project to an Astro Deployment, open that deployment's Airflow UI,
and add these Connections under **Admin → Connections**. Connection IDs must
match the DAG code exactly.

### PostgreSQL / Amazon RDS

Create a connection with:

| Airflow field | Value |
| --- | --- |
| Connection Id | `postgres_default` |
| Connection Type | `Postgres` |
| Host | RDS endpoint hostname |
| Database | `nasa_apod` (or the database name you selected) |
| Login | RDS database username |
| Password | RDS database password |
| Port | `5432` |
| Extra | `{"sslmode":"require"}` |

The PostgreSQL provider passes supported libpq parameters from Extra to
PostgreSQL. `sslmode=require` requests encrypted transport. For stricter
certificate verification, configure `verify-full` with the appropriate RDS
CA certificate available to the Airflow workers. Leave PostgreSQL Extra free of
NASA API settings: an `api_key` entry is not a valid PostgreSQL connection
option.

### NASA APOD HTTP API

Create another connection with:

| Airflow field | Value |
| --- | --- |
| Connection Id | `nasa_apod_api` |
| Connection Type | `HTTP` |
| Host | `https://api.nasa.gov` |
| Extra | `{"api_key":"YOUR_NASA_API_KEY"}` |

Replace the placeholder with your real key in the Airflow UI. Do not put it in
the DAG, README, source control, or a public screenshot. The DAG passes this
key to NASA as an API query parameter.

## 4. Add the DAG

Create `dags/nasa_apod_etl.py`:

```python
from datetime import datetime, timedelta

from airflow import DAG
from airflow.decorators import task
from airflow.providers.http.operators.http import HttpOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook


with DAG(
    dag_id="nasa_apod_postgres",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "retries": 3,
        "retry_delay": timedelta(minutes=1),
        "retry_exponential_backoff": True,
        "max_retry_delay": timedelta(minutes=10),
    },
    tags=["nasa", "postgres", "etl"],
) as dag:

    @task
    def create_table():
        hook = PostgresHook(postgres_conn_id="postgres_default")
        hook.run(
            """
            CREATE TABLE IF NOT EXISTS nasa_apod (
                id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                title TEXT NOT NULL,
                explanation TEXT,
                url TEXT NOT NULL,
                date DATE NOT NULL UNIQUE,
                media_type VARCHAR(20) NOT NULL,
                fetched_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );
            """
        )

    extract_apod = HttpOperator(
        task_id="extract_apod",
        http_conn_id="nasa_apod_api",
        endpoint="planetary/apod",
        method="GET",
        data={
            "api_key": "{{ conn.nasa_apod_api.extra_dejson.api_key }}"
        },
        response_filter=lambda response: response.json(),
        retries=4,
    )

    @task
    def transform_apod(payload):
        required_fields = ("title", "url", "date", "media_type")
        missing_fields = [
            field for field in required_fields if not payload.get(field)
        ]
        if missing_fields:
            raise ValueError(f"NASA APOD response is missing: {missing_fields}")

        return {
            "title": payload["title"],
            "explanation": payload.get("explanation", ""),
            "url": payload["url"],
            "date": payload["date"],
            "media_type": payload["media_type"],
        }

    @task
    def load_apod(record):
        hook = PostgresHook(postgres_conn_id="postgres_default")
        hook.run(
            """
            INSERT INTO nasa_apod
                (title, explanation, url, date, media_type)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (date) DO UPDATE SET
                title = EXCLUDED.title,
                explanation = EXCLUDED.explanation,
                url = EXCLUDED.url,
                media_type = EXCLUDED.media_type,
                fetched_at = NOW();
            """,
            parameters=(
                record["title"],
                record["explanation"],
                record["url"],
                record["date"],
                record["media_type"],
            ),
        )

    table_ready = create_table()
    transformed = transform_apod(extract_apod.output)
    loaded = load_apod(transformed)
    table_ready >> extract_apod
    table_ready >> loaded
```

The unique date and `ON CONFLICT` clause make manual reruns safe: the same
APOD date is updated instead of inserted repeatedly. NASA can return a video
for some dates; the `media_type` and `url` columns preserve those entries too.

## 5. Deploy to Astro and run the DAG

1. Log in to Astro CLI and create/select an Astro Deployment in the Astro
   interface.
2. From this project directory, deploy the project using the Astro CLI:

   ```bash
   astro login
   astro deploy
   ```

   If prompted, select the intended workspace and Deployment. Review the
   deployment target before confirming.
3. Open the Deployment's Airflow UI and confirm the DAG
   `nasa_apod_postgres` appears without import errors.
4. In **Admin → Connections**, verify both `postgres_default` and
   `nasa_apod_api` are configured in this cloud Airflow environment. Local
   `airflow_settings.yaml` or `.env` values are not automatically the cloud
   Deployment's Connections.
5. Unpause the DAG if necessary and trigger it manually. Watch the Graph or
   Grid view. `create_table`, `extract_apod`, `transform_apod`, and `load_apod`
   should all succeed.
6. If a task fails, inspect its task log. Check NASA key/API quota for extract
   failures; check the RDS endpoint, security-group route, database name, and
   credentials for Postgres connection failures.

The daily schedule runs after the initial manual test. The DAG is configured
with `catchup=False`, so it does not backfill every date since its start date.

## 6. Verify the saved record in DBeaver

In DBeaver, create a PostgreSQL connection using:

- **Host:** the RDS endpoint hostname
- **Port:** `5432`
- **Database:** `nasa_apod`
- **Username / Password:** the RDS database credentials
- **SSL:** enabled; use the RDS CA certificate if your SSL mode requires it

Connect and run:

```sql
SELECT
    id,
    title,
    date,
    media_type,
    url,
    fetched_at
FROM nasa_apod
ORDER BY date DESC;
```

You should see today's APOD (or the latest NASA response date) after
`load_apod` succeeds. To check the total number of stored dates:

```sql
SELECT COUNT(*) AS saved_apod_days
FROM nasa_apod;
```

## Troubleshooting

- **DAG is missing or has import errors:** run `astro dev parse`, check task
  provider packages in `requirements.txt`, then redeploy.
- **NASA returns HTTP 403/500:** confirm the API key is in the
  `nasa_apod_api` Extra JSON, the host is correct, and the key's quota is
  available. Transient task errors are retried with exponential backoff.
- **Postgres reports `invalid connection option "api_key"`:** remove the
  `api_key` from `postgres_default` Extra. It belongs only to the NASA HTTP
  Connection.
- **Airflow cannot reach RDS:** verify the Astro-to-AWS network route, RDS
  endpoint, port `5432`, and inbound rules on the RDS security group. Do not
  solve this by allowing traffic from every IP.
- **DBeaver times out while Airflow works:** add your current client IP to the
  RDS security group separately; Astro worker access does not automatically
  grant your laptop access.
- **No row appears in DBeaver:** confirm `load_apod` succeeded, select the same
  database configured in `postgres_default`, and refresh the schema/table
  navigator.

## Security and cleanup

- Never commit API keys, RDS passwords, or connection JSON containing secrets.
- Do not expose RDS port `5432` to all internet addresses.
- Stop or delete the Astro Deployment and RDS instance when finished. Check
  whether the RDS instance has a retained snapshot or other billable resources.
