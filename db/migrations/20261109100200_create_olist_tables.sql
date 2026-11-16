-- migrate:up
CREATE TABLE customers(
    customer_id TEXT PRIMARY KEY, -- this for the each order
    customer_unique_id TEXT NOT NULL, -- the real customer identity
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);

CREATE TABLE sellers(
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
);

CREATE TABLE products(
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER   
);

CREATE TABLE product_category_translation(
    product_category_name         TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
);

CREATE TABLE orders (
    order_id                      TEXT PRIMARY KEY,
    customer_id                   TEXT NOT NULL REFERENCES customers(customer_id),
    order_status                  TEXT NOT NULL CHECK (order_status IN
        ('created','approved','invoiced','processing','shipped','delivered','unavailable','canceled')),
    order_purchase_timestamp      TIMESTAMP NOT NULL,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_items (
    order_id            TEXT NOT NULL REFERENCES orders(order_id),
    order_item_id       INTEGER NOT NULL,
    product_id          TEXT NOT NULL REFERENCES products(product_id),
    seller_id           TEXT NOT NULL REFERENCES sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    freight_value       NUMERIC(10,2) NOT NULL CHECK (freight_value >= 0),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE payments (
    order_id             TEXT NOT NULL REFERENCES orders(order_id),
    payment_sequential   INTEGER NOT NULL,
    payment_type         TEXT NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value        NUMERIC(10,2) NOT NULL CHECK (payment_value >= 0),
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE INDEX idx_customers_unique_id       ON customers(customer_unique_id);
CREATE INDEX idx_orders_customer_id        ON orders(customer_id);
CREATE INDEX idx_orders_purchase_ts        ON orders(order_purchase_timestamp);
CREATE INDEX idx_order_items_product_id    ON order_items(product_id);
CREATE INDEX idx_order_items_seller_id     ON order_items(seller_id);


-- migrate:down
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_category_translation;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS customers;