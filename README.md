# E-commerce Data Engineering Pipeline

Postgres is the OLTP source system. Airflow will extract from it to S3, load into Snowflake, and dbt will model it.

## Local setup
    cp .env.example .env
    make up && make migrate && make seed
    make queries
