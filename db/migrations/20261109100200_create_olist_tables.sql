-- migrate:up
CREATE TABLE customers(
    customer_id TEXT PRIMARY KEY, -- this for the each order
    customer_unique_id TEXT NOT NULL, -- the real customer identity
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
)

CREATE TABLE sellers(
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
)

CREATE TABLE products(
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_length INTEGER
    product_description_length INTEGER
    product_photos_qty INTEGER
    product_weight_g INTEGER
    product_length_cm INTEGER
    product_height_cm INTEGER
    product_width_cm INTEGER   
)

CREATE TABLE product_category_translation(
    product_category_name         TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
)

CREATE TABLE orders(
    order_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL REFERENCES customers(customer_id)
    order_status
)