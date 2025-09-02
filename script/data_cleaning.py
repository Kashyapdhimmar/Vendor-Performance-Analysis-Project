# Step 1: Load only a subset of data for testing
import pandas as pd
from sqlalchemy import create_engine

# SQLAlchemy engine
# Replace with your actual credentials locally
engine = create_engine("postgresql+psycopg2://<USERNAME>:<PASSWORD>@localhost:5432/vendor_analysis")

# Load only first 1000 rows from each table for cleaning/testing
purchases = pd.read_sql("SELECT * FROM purchases LIMIT 1000;", engine)
sales = pd.read_sql("SELECT * FROM sales LIMIT 1000;", engine)
begin_inventory = pd.read_sql("SELECT * FROM begin_inventory LIMIT 1000;", engine)
end_inventory = pd.read_sql("SELECT * FROM end_inventory LIMIT 1000;", engine)
vendor_invoice = pd.read_sql("SELECT * FROM vendor_invoice LIMIT 1000;", engine)
purchase_prices = pd.read_sql("SELECT * FROM purchase_prices LIMIT 1000;", engine)

print(purchases.head())
print(sales.head())


# Step 2: Data Cleaning & Filtering
import pandas as pd
from sqlalchemy import create_engine

# SQLAlchemy engine
# Replace with your actual credentials locally
engine = create_engine("postgresql+psycopg2://<USERNAME>:<PASSWORD>@localhost:5432/vendor_analysis")

# ------------------------
# Load small subset for testing
# ------------------------
purchases = pd.read_sql("SELECT * FROM purchases LIMIT 1000;", engine)
sales = pd.read_sql("SELECT * FROM sales LIMIT 1000;", engine)
begin_inventory = pd.read_sql("SELECT * FROM begin_inventory LIMIT 1000;", engine)
end_inventory = pd.read_sql("SELECT * FROM end_inventory LIMIT 1000;", engine)
vendor_invoice = pd.read_sql("SELECT * FROM vendor_invoice LIMIT 1000;", engine)
purchase_prices = pd.read_sql("SELECT * FROM purchase_prices LIMIT 1000;", engine)

# ------------------------
# Cleaning & Filtering
# ------------------------

# Purchases: lowercase column names
purchases_clean = purchases[
    (purchases['quantity'] > 0) &
    (purchases['purchaseprice'] > 0) &
    (purchases['dollars'] > 0)
].copy()

# Optional: Profit Margin
purchases_clean['profitmargin'] = (
    purchases_clean['dollars'] - (purchases_clean['quantity'] * purchases_clean['purchaseprice'])
) / purchases_clean['dollars']

# Sales: lowercase column names
sales_clean = sales[
    (sales['salesquantity'] > 0) &
    (sales['salesdollars'] > 0)
].copy()

# Begin Inventory
begin_inventory_clean = begin_inventory[
    (begin_inventory['onhand'] > 0) &
    (begin_inventory['price'] > 0)
].copy()

# End Inventory
end_inventory_clean = end_inventory[
    (end_inventory['onhand'] > 0) &
    (end_inventory['price'] > 0)
].copy()

# Vendor Invoice
vendor_invoice_clean = vendor_invoice[
    (vendor_invoice['quantity'] > 0) &
    (vendor_invoice['dollars'] > 0)
].copy()

# Purchase Prices
purchase_prices_clean = purchase_prices[
    (purchase_prices['price'] > 0)
].copy()

# Preview cleaned data
print("Purchases Cleaned:", purchases_clean.shape)
print("Sales Cleaned:", sales_clean.shape)
print("Begin Inventory Cleaned:", begin_inventory_clean.shape)
print("End Inventory Cleaned:", end_inventory_clean.shape)
print("Vendor Invoice Cleaned:", vendor_invoice_clean.shape)
print("Purchase Prices Cleaned:", purchase_prices_clean.shape)

# Step 3: Work in Chunks for Full Dataset
import pandas as pd
from sqlalchemy import create_engine

# SQLAlchemy engine
# Replace with your actual credentials locally
engine = create_engine("postgresql+psycopg2://<USERNAME>:<PASSWORD>@localhost:5432/vendor_analysis")

# Function to clean chunks for each table
def clean_purchases(chunk):
    chunk_clean = chunk[
        (chunk['quantity'] > 0) &
        (chunk['purchaseprice'] > 0) &
        (chunk['dollars'] > 0)
    ].copy()
    chunk_clean['profitmargin'] = (chunk_clean['dollars'] - (chunk_clean['quantity'] * chunk_clean['purchaseprice'])) / chunk_clean['dollars']
    return chunk_clean

def clean_sales(chunk):
    return chunk[(chunk['salesquantity'] > 0) & (chunk['salesdollars'] > 0)].copy()

def clean_inventory(chunk):
    return chunk[(chunk['onhand'] > 0) & (chunk['price'] > 0)].copy()

def clean_vendor_invoice(chunk):
    return chunk[(chunk['quantity'] > 0) & (chunk['dollars'] > 0)].copy()

def clean_purchase_prices(chunk):
    return chunk[chunk['price'] > 0].copy()

# Dictionary with table names and cleaning functions
tables = {
    'purchases': clean_purchases,
    'sales': clean_sales,
    'begin_inventory': clean_inventory,
    'end_inventory': clean_inventory,
    'vendor_invoice': clean_vendor_invoice,
    'purchase_prices': clean_purchase_prices
}

# Dictionary to store cleaned full data
cleaned_data = {}

# Process each table in chunks
chunksize = 5000  # adjust based on your RAM
for table, clean_func in tables.items():
    print(f"Processing {table}...")
    chunks = pd.read_sql(f"SELECT * FROM {table};", engine, chunksize=chunksize)
    cleaned_chunks = [clean_func(chunk) for chunk in chunks]
    cleaned_data[table] = pd.concat(cleaned_chunks, ignore_index=True)
    print(f"{table} cleaned shape:", cleaned_data[table].shape)

# Access cleaned tables
purchases_full_cleaned = cleaned_data['purchases']
sales_full_cleaned = cleaned_data['sales']
begin_inventory_full_cleaned = cleaned_data['begin_inventory']
end_inventory_full_cleaned = cleaned_data['end_inventory']
vendor_invoice_full_cleaned = cleaned_data['vendor_invoice']
purchase_prices_full_cleaned = cleaned_data['purchase_prices']

# Preview
print(purchases_full_cleaned.head())
print(sales_full_cleaned.head())


# Function to save a large DataFrame to SQL in chunks
def to_sql_in_chunks(df, table_name, engine, chunksize=5000):
    print(f"Saving {table_name} in chunks...")
    df.to_sql(name=table_name, con=engine, if_exists='replace', index=False, chunksize=chunksize)
    print(f"{table_name} saved successfully!")

# Save all cleaned tables in chunks
to_sql_in_chunks(purchases_full_cleaned, 'purchases_cleaned', engine)
to_sql_in_chunks(sales_full_cleaned, 'sales_cleaned', engine)
to_sql_in_chunks(begin_inventory_full_cleaned, 'begin_inventory_cleaned', engine)
to_sql_in_chunks(end_inventory_full_cleaned, 'end_inventory_cleaned', engine)
to_sql_in_chunks(vendor_invoice_full_cleaned, 'vendor_invoice_cleaned', engine)
to_sql_in_chunks(purchase_prices_full_cleaned, 'purchase_prices_cleaned', engine)


