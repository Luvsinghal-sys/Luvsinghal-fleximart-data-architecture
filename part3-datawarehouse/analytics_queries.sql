-- Query 1: Monthly Sales Drill-Down Analysis
-- Business Scenario: The CEO wants to see sales performance broken down by time periods.
-- Demonstrates: Drill-down from Year -> Quarter -> Month

SELECT 
    year, 
    quarter, 
    month_name, 
    SUM(total_amount) AS total_sales, 
    SUM(quantity_sold) AS total_quantity
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY year, quarter, month_name
ORDER BY year, d.month;

-- Query 2: Product Performance Analysis
-- Business Scenario: Identify top 10 products by revenue and their contribution percentage.

SELECT 
    p.product_name, 
    p.category, 
    SUM(f.quantity_sold) AS units_sold, 
    SUM(f.total_amount) AS revenue,
    ROUND((SUM(f.total_amount) / SUM(SUM(f.total_amount)) OVER()) * 100, 2) AS revenue_percentage
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- Query 3: Customer Segmentation Analysis
-- Business Scenario: Segment customers into High Value (>50k), Medium Value (20k-50k), and Low Value (<20k).

WITH CustomerSpending AS (
    SELECT 
        customer_key, 
        SUM(total_amount) AS total_spent
    FROM fact_sales
    GROUP BY customer_key
)
SELECT 
    CASE 
        WHEN total_spent > 50000 THEN 'High Value'
        WHEN total_spent BETWEEN 20000 AND 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(customer_key) AS customer_count,
    SUM(total_spent) AS total_revenue,
    AVG(total_spent) AS avg_revenue_per_customer
FROM CustomerSpending
GROUP BY customer_segment
ORDER BY total_revenue DESC;