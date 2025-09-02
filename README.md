# Vendor Performance Analysis

## Overview
This project analyzes **vendor performance** for a retail business using **SQL**, **Python**, and **Power BI**. The goal is to understand vendor contribution, profit margins, sales vs. purchase trends, and inventory efficiency[web:1].

## Key Components

- **SQL**: Table creation, data import, and aggregate queries.
- **Python**: Data cleaning, analysis, and visualization using Pandas, Matplotlib, and Seaborn.
- **Power BI**: Interactive dashboards for vendor performance, profit, and inventory insights.

## Getting Started

### 1. Clone the Repository

### 2. SQL Database Setup

- Create a PostgreSQL database (e.g., `vendor_analysis`).
- Update database credentials in:
  - `script/data_cleaning.py`
  - `notebook/vendor_analysis.ipynb`
- Example connection string:from sqlalchemy import create_engine

engine = create_engine("postgresql+psycopg2://<USERNAME>:<PASSWORD>@localhost:5432/vendor_analysis")

- Run SQL scripts:
- `sql/create_tables.sql` (for table creation)
- Load CSV data using the provided `COPY` commands in the SQL scripts.

### 3. Run Data Cleaning & Analysis

- Python script: `script/data_cleaning.py`
- Jupyter Notebook: `notebook/vendor_analysis.ipynb`

### 4. Power BI Dashboard

- Open `dashboard/Vendor_Analysis.pbix` in Power BI Desktop.
- Connect to your PostgreSQL DB or use exported clean CSVs for visuals.

## Features

- **Vendor Profit Analysis**: Rank top & bottom vendors by profit (with/without freight).
- **Sales & Purchase Insights**: Revenue, costs, sold quantities per vendor.
- **Inventory Insights**: Start vs. end inventory, turnover, and unsold capital.
- **Visualization**: Bar charts, pivot tables & interactive dashboard for actionable insights.

## Screenshots

## Screenshots

### SQL Tables & Queries
<img src="https://github.com/Kashyapdhimmar/Vendor-Performance-Analysis-Project/blob/b7292adad3f7f40e31152ccb945f42391564f6cd/dashboard/images/SQL%20Tables.png" width="700"/>
<img src="https://github.com/Kashyapdhimmar/Vendor-Performance-Analysis-Project/blob/b7292adad3f7f40e31152ccb945f42391564f6cd/dashboard/images/SQL%20Queries.png" width="700"/>

### Python Data Cleaning (VS Code)
<img src="https://github.com/Kashyapdhimmar/Vendor-Performance-Analysis-Project/blob/b7292adad3f7f40e31152ccb945f42391564f6cd/dashboard/images/Python%20Data%20Cleaning.png" width="700"/>

### Jupyter Notebook Analysis
<img src="https://github.com/Kashyapdhimmar/Vendor-Performance-Analysis-Project/blob/b7292adad3f7f40e31152ccb945f42391564f6cd/dashboard/images/Jupyter%20Notebook%20Analysis.png" width="700"/>

### Power BI Dashboard
<img src="https://github.com/Kashyapdhimmar/Vendor-Performance-Analysis-Project/blob/b7292adad3f7f40e31152ccb945f42391564f6cd/dashboard/images/Power%20BI%20Dashboard.png" width="700"/>

> **Note:** Raw CSV data files are *not* included in this repository due to size/privacy concerns. Please use your own data or request access to the CSVs to run the complete project.
