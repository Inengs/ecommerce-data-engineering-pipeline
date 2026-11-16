TRUNCATE payments, order_items, orders, product_category_translation, products, sellers, customers;

COPY customers                    FROM '/data/olist_customers_dataset.csv'      WITH (FORMAT csv, HEADER true);
COPY sellers                      FROM '/data/olist_sellers_dataset.csv'        WITH (FORMAT csv, HEADER true);
COPY products                     FROM '/data/olist_products_dataset.csv'       WITH (FORMAT csv, HEADER true);
COPY product_category_translation FROM '/data/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true);
COPY orders                       FROM '/data/olist_orders_dataset.csv'         WITH (FORMAT csv, HEADER true);
COPY order_items                  FROM '/data/olist_order_items_dataset.csv'    WITH (FORMAT csv, HEADER true);
COPY payments                     FROM '/data/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true);
