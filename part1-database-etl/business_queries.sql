-- Query 1: Customer Purchase History
-- Business Question: Report showing customer name, email, total orders, and total spent.
-- Filter: Only customers who have placed at least 2 orders and spent more than 5,000.

SELECT 
    c.first_name, 
    c.last_name, 
    c.email, 
    COUNT(o.transaction_id) AS total_orders, 
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(o.transaction_id) >= 2 AND SUM(o.total_amount) > 5000
ORDER BY total_spent DESC;


-- Query 2: Product Sales Analysis
-- Business Question: Category name, number of products sold, total quantity, and revenue.
-- Filter: Categories generating more than 10,000 in revenue.

SELECT 
    p.category, 
    COUNT(DISTINCT p.product_id) AS num_products, 
    SUM(oi.quantity) AS total_quantity_sold, 
    SUM(oi.subtotal) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
HAVING SUM(oi.subtotal) > 10000
ORDER BY total_revenue DESC;


-- Query 3: Monthly Sales Trend
-- Business Question: Monthly sales trends for 2024 with running total revenue.

SELECT 
    STRFTIME('%m', o.transaction_date) AS month_num,
    COUNT(o.transaction_id) AS total_orders,
    SUM(o.total_amount) AS monthly_revenue,
    SUM(SUM(o.total_amount)) OVER (ORDER BY STRFTIME('%m', o.transaction_date)) AS cumulative_revenue
FROM orders o
WHERE o.transaction_date LIKE '2024%'
GROUP BY STRFTIME('%m', o.transaction_date)
ORDER BY month_num;