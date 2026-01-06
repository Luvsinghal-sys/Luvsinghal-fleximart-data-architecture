# Database Schema Documentation

## 1. Entity-Relationship Description

* **ENTITY: customers**
    * **Purpose:** Stores personal details of registered users.
    * **Attributes:**
        * `customer_id`: Unique identifier (Primary Key).
        * `first_name`, `last_name`: Name of the customer.
        * `email`: Contact email (Unique).
        * `phone`: Contact number (Standardized).
    * **Relationships:** A customer can place many orders (1:M with `orders`).

* **ENTITY: products**
    * **Purpose:** Stores inventory information.
    * **Attributes:**
        * `product_id`: Unique identifier (Primary Key).
        * `category`: Product classification (e.g., Electronics).
        * `price`: Cost per unit.
    * **Relationships:** A product can appear in many order items (1:M with `order_items`).

* **ENTITY: orders**
    * **Purpose:** Represents a sales transaction header.
    * **Attributes:**
        * `transaction_id`: Unique order identifier.
        * `customer_id`: Link to the customer who bought the items.
        * `total_amount`: Total cost of the transaction.
    * **Relationships:** Belongs to one customer; contains many items.

* **ENTITY: order_items**
    * **Purpose:** Stores the specific items within an order.
    * **Attributes:**
        * `order_id`: Link to the parent order.
        * `product_id`: Link to the product sold.
        * `quantity`: Amount purchased.
        * `subtotal`: Cost for this line item.

## 2. Normalization Explanation

The database is designed in **Third Normal Form (3NF)**:
1.  **1NF:** All fields contain atomic values (no comma-separated lists).
2.  **2NF:** All non-key attributes depend on the entire primary key. We separated `order_items` so that product details don't repeat in the `orders` table.
3.  **3NF:** No transitive dependencies. For example, we do not store the Customer's City in the `orders` table. To find the city of an order, we join `orders` with `customers`. This prevents data anomalies; if a customer moves, we update only the `customers` table.

## 3. Sample Data Representation

**Table: Customers**
| customer_id | first_name | email |
| :--- | :--- | :--- |
| C001 | Rahul | rahul.sharma@gmail.com |
| C002 | Priya | priya.patel@yahoo.com |

**Table: Products**
| product_id | category | price |
| :--- | :--- | :--- |
| P001 | Electronics | 45999.00 |
| P002 | Fashion | 3499.00 |