import pandas as pd
import re
from sqlalchemy import create_engine

# 1. SETUP DATABASE CONNECTION (Using SQLite for simplicity)
# This will create a file named 'fleximart.db' in your folder
db_engine = create_engine('sqlite:///fleximart.db')

def clean_customers(df):
    print("--- Cleaning Customers ---")
    # Remove duplicates
    df = df.drop_duplicates(subset=['customer_id'], keep='first')
    
    # Fix Phone Numbers (remove +91, spaces, dashes)
    def clean_phone(phone):
        if pd.isna(phone): return None
        digits = re.sub(r'\D', '', str(phone)) # Keep only numbers
        if len(digits) > 10: digits = digits[-10:] # Take last 10 digits
        return digits

    df['phone'] = df['phone'].apply(clean_phone)
    
    # Fix Emails (Fill missing with placeholder)
    df['email'] = df['email'].fillna('missing@fleximart.com')
    
    # Standardize City names
    df['city'] = df['city'].str.title()
    
    # Fix Dates
    df['registration_date'] = pd.to_datetime(df['registration_date'], errors='coerce').dt.date
    
    return df

def clean_products(df):
    print("--- Cleaning Products ---")
    # Fix Category names (Electronics vs ELECTRONICS)
    df['category'] = df['category'].str.strip().str.title()
    
    # Fix Missing Prices (Fill with 0 or average)
    df['price'] = pd.to_numeric(df['price'], errors='coerce').fillna(0)
    
    # Fix Missing Stock
    df['stock_quantity'] = pd.to_numeric(df['stock_quantity'], errors='coerce').fillna(0).astype(int)
    
    return df

def clean_sales(df):
    print("--- Cleaning Sales ---")
    # Remove duplicates
    df = df.drop_duplicates(subset=['transaction_id'])
    
    # Remove rows with missing Customer or Product IDs
    df = df.dropna(subset=['customer_id', 'product_id'])
    
    # Fix Dates
    df['transaction_date'] = pd.to_datetime(df['transaction_date'], errors='coerce').dt.date
    
    # Ensure numbers are correct
    df['quantity'] = pd.to_numeric(df['quantity'], errors='coerce').fillna(0).astype(int)
    df['unit_price'] = pd.to_numeric(df['unit_price'], errors='coerce')
    
    return df

# --- MAIN EXECUTION ---
try:
    # 1. Extract (Read Files)
    cust_df = pd.read_csv('customers_raw.csv')
    prod_df = pd.read_csv('products_raw.csv')
    sales_df = pd.read_csv('sales_raw.csv')

    # 2. Transform (Clean Data)
    clean_cust = clean_customers(cust_df)
    clean_prod = clean_products(prod_df)
    clean_sales_data = clean_sales(sales_df)

    # Prepare specific tables for the Database Schema
    # Creating 'orders' table data
    orders_df = clean_sales_data[['transaction_id', 'customer_id', 'transaction_date', 'status']].copy()
    orders_df['total_amount'] = clean_sales_data['quantity'] * clean_sales_data['unit_price']
    
    # Creating 'order_items' table data
    order_items_df = clean_sales_data[['transaction_id', 'product_id', 'quantity', 'unit_price']].copy()
    order_items_df['subtotal'] = order_items_df['quantity'] * order_items_df['unit_price']
    # Rename transaction_id to order_id for the database schema
    order_items_df = order_items_df.rename(columns={'transaction_id': 'order_id'})

    # 3. Load (Save to Database)
    clean_cust.to_sql('customers', db_engine, if_exists='replace', index=False)
    clean_prod.to_sql('products', db_engine, if_exists='replace', index=False)
    orders_df.to_sql('orders', db_engine, if_exists='replace', index=False)
    order_items_df.to_sql('order_items', db_engine, if_exists='replace', index=False)

    print("SUCCESS! Data cleaned and loaded into 'fleximart.db'")

except Exception as e:
    print(f"Error: {e}")
