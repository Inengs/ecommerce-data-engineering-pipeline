-- How many customers are registered?
SELECT COUNT(DISTINCT customer_unique_id) AS registered_customers FROM customers; -- for number of registered customers

-- How many orders were placed?
SELECT COUNT(order_id) AS orders_placed FROM orders; -- number of placed orders.


-- Question 3 to Question 5 EXCLUDE canceled and unavailable transaction
-- What are the top five products by sales?
SELECT p.product_id,
       p.product_category_name,
       SUM(oi.price) AS revenue,
       COUNT(*)      AS units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o   ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY p.product_id, p.product_category_name
ORDER BY revenue DESC
LIMIT 5; -- top five products by sales(revenue)

-- What is the total revenue?
SELECT SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable');

-- Which customers placed the most orders?
SELECT c.customer_unique_id,
    COUNT(*) AS orders
FROM orders o
JOIN customers c on c.customer_id = o.customer_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id
ORDER BY orders DESC
LIMIT 10;

-- Rank products by revenue.
WITH product_revenue AS (
    SELECT oi.product_id,
        SUM(oi.price) AS revenue
    FROM order_items oi
        JOIN orders o USING (order_id)
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY oi.product_id
)
SELECT product_id,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank
LIMIT BY 20;

-- Calculate monthly sales.
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS sales_month,
    SUM(oi.price) AS monthly_sales
FROM order_items oi
JOIN orders o USING (order_id)
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY sales_month
ORDER BY sales_month;

-- Identify each customer's most recent order.
WITH ranked AS (
    SELECT c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
           ROW_NUMBER() OVER (
               PARTITION BY c.customer_unique_id
               ORDER BY o.order_purchase_timestamp DESC
           ) AS rn
    FROM orders o
    JOIN customers c USING (customer_id)
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
)
SELECT customer_unique_id, order_id, order_purchase_timestamp
FROM ranked
WHERE rn = 1
ORDER BY order_purchase_timestamp DESC;

-- Calculate running revenue.
WITH daily_sales AS (
    SELECT 
        CAST(o.order_purchase_timestamp AS DATE) AS order_date,
        SUM(oi.price) AS daily_revenue
    FROM orders o
    JOIN order_items oi USING (order_id)
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY CAST(o.order_purchase_timestamp AS DATE)
)
SELECT 
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY order_date) AS running_total_revenue
FROM daily_sales
ORDER BY order_date;

-- Compare current-month sales with previous-month sales.
