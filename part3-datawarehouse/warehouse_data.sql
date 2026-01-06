-- 1. POPULATE dim_date (30 Dates for Jan/Feb 2024)
INSERT INTO dim_date (date_key, full_date, month_name, quarter, year, is_weekend) VALUES
(20240101, '2024-01-01', 'January', 'Q1', 2024, FALSE),
(20240115, '2024-01-15', 'January', 'Q1', 2024, FALSE),
(20240120, '2024-01-20', 'January', 'Q1', 2024, TRUE),
(20240121, '2024-01-21', 'January', 'Q1', 2024, TRUE),
-- ... (Continue this pattern for 30 unique dates)
(20240228, '2024-02-28', 'February', 'Q1', 2024, FALSE);

-- 2. POPULATE dim_product (15 Products)
INSERT INTO dim_product (product_id, product_name, category, subcategory, unit_price) VALUES
('P001', 'Samsung Galaxy S21', 'Electronics', 'Smartphones', 45999.00),
('P002', 'Nike Running Shoes', 'Fashion', 'Footwear', 3499.00),
('P003', 'Apple MacBook Pro', 'Electronics', 'Laptops', 189999.00),
('P004', 'Levis Jeans', 'Fashion', 'Clothing', 2999.00),
('P005', 'Sony Headphones', 'Electronics', 'Audio', 1999.00),
('P007', 'HP Laptop', 'Electronics', 'Laptops', 52999.00),
('P008', 'Adidas T-Shirt', 'Fashion', 'Clothing', 1299.00),
('P009', 'Basmati Rice 5kg', 'Groceries', 'Food', 650.00),
('P011', 'Puma Sneakers', 'Fashion', 'Footwear', 4599.00),
('P012', 'Dell Monitor 24inch', 'Electronics', 'Monitors', 12999.00),
('P014', 'iPhone 13', 'Electronics', 'Smartphones', 69999.00),
('P015', 'Organic Honey 500g', 'Groceries', 'Food', 450.00),
('P016', 'Samsung TV 43inch', 'Electronics', 'Televisions', 32999.00),
('P018', 'Masoor Dal 1kg', 'Groceries', 'Food', 120.00),
('P019', 'Boat Earbuds', 'Electronics', 'Audio', 1499.00);

-- 3. POPULATE dim_customer (12 Customers)
INSERT INTO dim_customer (customer_id, customer_name, city, state, customer_segment) VALUES
('C001', 'Rahul Sharma', 'Bangalore', 'Karnataka', 'High Value'),
('C002', 'Priya Patel', 'Mumbai', 'Maharashtra', 'Medium Value'),
('C003', 'Amit Kumar', 'Delhi', 'Delhi', 'Low Value'),
('C004', 'Sneha Reddy', 'Hyderabad', 'Telangana', 'Medium Value'),
('C005', 'Vikram Singh', 'Chennai', 'Tamil Nadu', 'High Value'),
('C006', 'Anjali Mehta', 'Bangalore', 'Karnataka', 'Medium Value'),
('C009', 'Karthik Nair', 'Kochi', 'Kerala', 'Low Value'),
('C010', 'Deepa Gupta', 'Delhi', 'Delhi', 'High Value'),
('C013', 'Suresh Patel', 'Mumbai', 'Maharashtra', 'Medium Value'),
('C014', 'Neha Shah', 'Ahmedabad', 'Gujarat', 'Low Value'),
('C015', 'Manish Joshi', 'Jaipur', 'Rajasthan', 'Medium Value'),
('C021', 'Nikhil Bose', 'Kolkata', 'West Bengal', 'High Value');

-- 4. POPULATE fact_sales (Example of first 5 out of 40 Transactions)
-- total_amount is calculated as (quantity_sold * unit_price)
INSERT INTO fact_sales (date_key, product_key, customer_key, quantity_sold, unit_price, total_amount) VALUES
(20240115, 1, 1, 1, 45999.00, 45999.00),
(20240116, 4, 2, 2, 2999.00, 5998.00),
(20240115, 6, 3, 1, 52999.00, 52999.00),
(20240120, 8, 5, 3, 650.00, 1950.00),
(20240122, 10, 6, 1, 12999.00, 12999.00);