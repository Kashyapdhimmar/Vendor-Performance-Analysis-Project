# Vendor Performance Analysis Project

## Overview
This project analyzes vendor performance for a retail business using SQL, Python, and Power BI. The goal is to understand vendor contribution, profit margins, sales vs. purchase trends, and inventory efficiency. 

Key components:
- **SQL**: Create tables, import data, and perform aggregations.
- **Python**: Data cleaning, analysis, and visualization using Pandas, Matplotlib, and Seaborn.
- **Power BI**: Interactive dashboards for top/bottom vendors, profit analysis, and inventory insights.

---

## Folder Structure

Vendor_Performance_Analysis/
│
├── dashboard/ # Power BI files & assets
├── notebook/ # Jupyter notebooks
├── script/ # Python scripts for data cleaning/analysis
├── sql/ # SQL scripts (table creation & queries)


---

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/<your-username>/vendor-performance-analysis.git
cd vendor-performance-analysis

2. SQL Database Setup

Create a PostgreSQL database (e.g., vendor_analysis).
Update your connection credentials in:
script/data_cleaning.py
notebook/vendor_analysis.ipynb

from sqlalchemy import create_engine

engine = create_engine("postgresql+psycopg2://<USERNAME>:<PASSWORD>@localhost:5432/vendor_analysis")

Run the SQL scripts in sql/create_tables.sql to create tables.
Load the CSV data using the provided COPY commands in the SQL scripts.

3. Run Data Cleaning & Analysis

Python scripts: script/data_cleaning.py
Jupyter Notebook: notebook/vendor_analysis.ipynb

4. Power BI Dashboard
Open dashboard/Vendor_Analysis.pbix in Power BI Desktop.
Connect to the PostgreSQL database or use cleaned CSVs for visuals.

Features

Vendor Profit Analysis: Top & bottom vendors by profit including/excluding freight.
Sales & Purchase Insights: Total revenue, cost, quantities per vendor.
Inventory Insights: Begin vs. end inventory, turnover, and unsold capital.
Visualization: Bar charts, pivot tables, and dashboards for quick insights.

5. Screenshots

<img src="dashboard/images/sql_tables.png" alt="SQL Tables" width="600">
<img src="dashboard/images/python_data_cleaning.png" alt="Python Data Cleaning" width="600">
<img src="dashboard/images/jupyter_analysis.png" alt="Jupyter Notebook Analysis" width="600">
<img src="dashboard/images/powerbi_dashboard.png" alt="Power BI Dashboard" width="600">

**Note:** The raw CSV data files are not included in this repository due to size/privacy. You will need to use your own data or request access to the CSVs to run the full project.


