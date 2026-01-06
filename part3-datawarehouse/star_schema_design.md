Task 3.1: Star Schema Design Documentation
Section 1: Schema Overview
Our data warehouse uses a Star Schema architecture to optimize query performance for FlexiMart's historical sales analysis222.


FACT TABLE: fact_sales
Grain: One row per product per order line item.
Business Process: Sales transactions.

Measures (Numeric Facts):
quantity_sold: Number of units sold.
unit_price: Price per unit at the time of sale6.
discount_amount: Discount applied.
total_amount: Final amount (Quantity $\times$ Unit Price - Discount).


Foreign Keys:
date_key $\rightarrow$ dim_date.
product_key $\rightarrow$ dim_product.
customer_key $\rightarrow$ dim_customer.


DIMENSION TABLE: dim_date
Purpose: Date dimension for time-based analysis.
Type: Conformed dimension.

Attributes: date_key (PK), full_date, day_of_week, month, month_name, quarter, year, and is_weekend.

DIMENSION TABLE: dim_product
Purpose: Stores descriptive attributes of products.

Attributes: product_key (PK), product_id, product_name, category, subcategory, and unit_price.

DIMENSION TABLE: dim_customer
Purpose: Stores descriptive attributes of customers.

Attributes: customer_key (PK), customer_id, customer_name, city, state, and customer_segment.


Section 2: Design Decisions
Granularity: We chose the transaction line-item level19. This allows for detailed analysis of product-level performance, which is essential for calculating accurate revenue per category and identifying top-selling items2020.


Surrogate Keys: We use Surrogate Keys (integers) instead of natural keys (like C001 or P001). This decouples the warehouse from changes in source systems, handles historical changes more efficiently, and improves join performance.
Drill-down and Roll-up: This design supports drill-down and roll-up (e.g., aggregating individual product sales into Categories) operations by utilizing the hierarchical attributes in our dimension tables2323.


Section 3: Sample Data Flow
Below is an example of how a single transaction flows from the source into the warehouse:
Source Transaction:

Order #T001, Customer "Rahul Sharma", Product "Samsung Galaxy S21", Qty: 1, Price: 45999.00 

Becomes in Data Warehouse:
fact_sales:
date_key: 20240115
product_key: 1
customer_key: 12
quantity_sold: 1
unit_price: 45999.00
total_amount: 45999.00 


dim_date: {date_key: 20240115, full_date: '2024-01-15', month: 1, quarter: 'Q1'...} 
dim_product: {product_key: 1, product_name: 'Samsung Galaxy S21', category: 'Electronics'...} 
dim_customer: {customer_key: 12, customer_name: 'Rahul Sharma', city: 'Bangalore'...} 