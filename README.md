# SQL Star Schema – Global Superstore Data Warehouse

##  Project Overview
This project demonstrates the design and implementation of a Data Warehouse using a Star Schema model on the Global Superstore dataset.

The objective was to clean raw sales data, perform ETL operations, build dimension and fact tables, and generate analytical insights using SQL.

This project was completed as part of the Data Analyst Internship – Task 9 (SQL Data Modeling).

---

## 🛠️ Tools & Technologies
- MySQL
- MySQL Workbench
- draw.io / MySQL Reverse Engineering (ER Diagram)
- Microsoft Excel (CSV Processing)
- GitHub

---

##  Dataset
- Global Superstore Sales Dataset
- Total Records: ~55,000+

---

##  Data Warehouse Design

###  Star Schema Structure

#### Fact Table
- `fact_sales`

#### Dimension Tables
- `dim_customer`
- `dim_product`
- `dim_region`
- `dim_date`

The fact table stores sales metrics and is connected to dimension tables using surrogate keys.

---

##  ETL Process

1. Imported raw CSV data into MySQL
2. Cleaned and standardized column names
3. Handled missing values (NULL conversion)
4. Created dimension tables using DISTINCT values
5. Generated surrogate keys
6. Built fact table using foreign key mapping
7. Validated record counts
8. Executed analytical queries

---

##  Key Features
- Star Schema implementation
- Data cleaning and transformation
- Surrogate key usage
- Foreign key relationships
- Analytical reporting
- Data validation

---

##  Project Files

| File Name | Description |
|-----------|-------------|
| `task9_star_schema.sql` | Complete SQL script for database creation and ETL |
| `star_schema_diagram.png` | Star schema ER diagram |
| `analysis_outputs.csv` | Output of analytical queries |
| `README.md` | Project documentation |

---

##  Sample Analysis Performed
- Total Sales by Year
- Top Customers by Profit
- Sales by Region
- Monthly Sales Trend
- Profit by Category

---

##  Results
- Successfully processed ~55,000 records
- Created normalized dimension tables
- Built fact table with proper key mapping
- Generated business insights using SQL joins

---

##  Learning Outcomes
- Data Warehousing concepts
- Star Schema modeling
- ETL workflow
- SQL optimization
- Data profiling and cleaning
- Analytical querying

---

##  Author
**Tazim Anwar**

Data Analyst Intern  
MCA Student  

---

##  Acknowledgment
This project was completed as part of the Data Analyst Internship program by Elevate Labs.

---

## 📬 Contact
For any queries or collaboration, feel free to connect via GitHub.
