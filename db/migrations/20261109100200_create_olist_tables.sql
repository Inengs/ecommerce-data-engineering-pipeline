-- migrate:up
CREATE TABLE customers(
    customer_id TEXT PRIMARY KEY, -- this for the each order
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT,
)