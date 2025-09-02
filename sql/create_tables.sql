-- Create Tables for Each CSV

DROP TABLE IF EXISTS purchases;
CREATE TABLE IF NOT EXISTS purchases (
    InventoryId VARCHAR(50),
    Store VARCHAR(100),
    Brand VARCHAR(100),
    Description VARCHAR(255),
    Size VARCHAR(50),
    VendorNumber INT,
    VendorName VARCHAR(100),
    PONumber VARCHAR(50),
    PODate DATE,
    ReceivingDate DATE,
    InvoiceDate DATE,
    PayDate DATE,
    PurchasePrice NUMERIC(10,2),
    Quantity INT,
    Dollars NUMERIC(12,2),
    Classification VARCHAR(50)
);

DROP TABLE IF EXISTS purchase_prices;
CREATE TABLE IF NOT EXISTS purchase_prices (
    Brand VARCHAR(100),
    Description VARCHAR(255),
    Price NUMERIC(10,2),
    Size VARCHAR(50),
    Volume NUMERIC(10,2),
    Classification VARCHAR(100),
    PurchasePrice NUMERIC(10,2),
    VendorNumber INT,
    VendorName VARCHAR(100)
);

DROP TABLE IF EXISTS vendor_invoice;
CREATE TABLE IF NOT EXISTS vendor_invoice (
    VendorNumber INT,
    VendorName VARCHAR(100),
    InvoiceDate DATE,
    PONumber VARCHAR(50),
    PODate DATE,
    PayDate DATE,
    Quantity INT,
    Dollars DECIMAL(12,2),
    Freight DECIMAL(12,2),
    Approval VARCHAR
);

DROP TABLE IF EXISTS begin_inventory;
CREATE TABLE IF NOT EXISTS begin_inventory (
    InventoryId TEXT PRIMARY KEY,
    Store VARCHAR(100),
    City VARCHAR(100),
    Brand VARCHAR(100),
    Description VARCHAR(255),
    Size VARCHAR(50),
    onHand INT,
    Price DECIMAL(10,2),
    startDate DATE
);

DROP TABLE IF EXISTS end_inventory;
CREATE TABLE IF NOT EXISTS end_inventory (
    InventoryId TEXT PRIMARY KEY,  
    Store VARCHAR(100),
    City VARCHAR(100),
    Brand VARCHAR(100),
    Description VARCHAR(255),
    Size VARCHAR(50),
    onHand INT,
    Price DECIMAL(10,2),
    endDate DATE
);

DROP TABLE IF EXISTS sales;
CREATE TABLE IF NOT EXISTS sales (
    InventoryId TEXT,
    Store VARCHAR(100),
    Brand VARCHAR(100),
    Description VARCHAR(255),
    Size VARCHAR(50),
    SalesQuantity INT,
    SalesDollars DECIMAL(12,2),
    SalesPrice DECIMAL(10,2),
    SalesDate DATE,
    Volume DECIMAL(12,2),
    Classification VARCHAR(100),
    ExciseTax DECIMAL(10,2),
    VendorNo INT,
    VendorName VARCHAR(100)
);

-- Import CSVs
COPY purchases(InventoryId, Store, Brand, Description, Size, VendorNumber, VendorName, PONumber, PODate, ReceivingDate, InvoiceDate, PayDate, PurchasePrice, Quantity, Dollars, Classification)
FROM 'E:\Kashyap\Projects\DA PROJECT\Vendor Performance Project\data\data\purchases.csv'
DELIMITER ','
CSV HEADER;

COPY purchase_prices(Brand, Description, Price, Size, Volume, Classification, PurchasePrice, VendorNumber, VendorName)
FROM 'E:\Kashyap\Projects\DA PROJECT\Vendor Performance Project\data\data\purchase_prices(Cleaned using Power Query).csv'
DELIMITER ','
CSV HEADER;

COPY vendor_invoice(VendorNumber,VendorName, InvoiceDate, PONumber, PODate, PayDate, Quantity, Dollars, Freight, Approval)
FROM 'E:\Kashyap\Projects\DA PROJECT\Vendor Performance Project\data\data\vendor_invoice.csv'
DELIMITER ','
CSV HEADER

COPY begin_inventory(InventoryId, Store, City, Brand, Description, Size, onHand, Price, startDate)
FROM 'E:\Kashyap\Projects\DA PROJECT\Vendor Performance Project\data\data\begin_inventory.csv'
DELIMITER ','
CSV HEADER

COPY end_inventory(InventoryId, Store, City, Brand, Description, Size, onHand, Price, endDate)
FROM 'E:\Kashyap\Projects\DA PROJECT\Vendor Performance Project\data\data\end_inventory.csv'
DELIMITER ','
CSV HEADER

COPY sales(InventoryId, Store, Brand, Description, Size, SalesQuantity, SalesDollars, SalesPrice, SalesDate, Volume, Classification, ExciseTax, VendorNo, VendorName)
FROM 'E:\Kashyap\Projects\DA PROJECT\Vendor Performance Project\data\data\sales.csv'
DELIMITER ','
CSV HEADER

SELECT * FROM purchases;
SELECT * FROM purchase_prices;
SELECT * FROM vendor_invoice;
SELECT * FROM begin_inventory;
SELECT * FROM end_inventory;
SELECT * FROM sales;



