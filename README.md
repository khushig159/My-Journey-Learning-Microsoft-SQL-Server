# Learning Microsoft SQL Server (MSSQL) 📚

This repository documents my journey learning Microsoft SQL Server, from installation to advanced queries and database management. It's designed for beginners and includes code examples with explanations. Whether you're just starting out or looking to refresh your skills, feel free to follow along! 

## Table of Contents

- **Introduction**
- **Prerequisites and Setup**
- **Basics**
- **Intermediate**
  - Joins & Relationships
  - Window Functions
  - NULL Handling and Safety
- **Advanced**
  - CTEs (Common Table Expressions)
  - Views
  - Tables: Permanent vs Temporary
  - Database Automation: Triggers
  - Stored Procedures: Reusable Logic
  - Performance Tuning: Indexes & Storage
  - Scalability: Table Partitioning
  - Advanced Queries: Subqueries & Metadata
- **SQL Performance Mastery: 30 Golden Tips**
- **How to Use This Repo**
- **Contributing**
- **License**
  
## Introduction
Welcome to my MSSQL learning repository! Here, I'll be sharing notes, SQL scripts, and resources as I progress through various topics in Microsoft SQL Server. The goal is to make database concepts **accessible and practical** for beginners.

Each lesson includes:
- Clear explanations
- Ready-to-run SQL code
- Sample data (in the `datasets/` folder)
- Best practices and common pitfalls

We’ll start from **zero** — installing SQL Server — and build up to advanced topics like joins, indexing, and stored procedures.

If you're new to databases, SQL Server is a powerful relational database management system (RDBMS) developed by Microsoft. It's widely used for storing, retrieving, and managing data efficiently.

## Prerequisites and Setup

Before diving into SQL, you'll need to set up Microsoft SQL Server on your machine. Below are step-by-step instructions for different operating systems. We'll also cover tools for interacting with the server.

### System Requirements
- **Windows**: Windows 10/11 or Server 2016+ (64-bit).
- **macOS/Linux**: Use Docker for SQL Server Express/Developer edition.
- At least 4 GB RAM (8 GB recommended), 6 GB free disk space.

### Downloading and Installing SQL Server

1. **Download SQL Server**:
   - Go to the official Microsoft SQL Server download page: [Download SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads).
   - Choose the **Developer Edition** (free for learning) or **Express Edition** for basic use.

2. **Installation on Windows**:
   - Run the downloaded installer.
   - Select "Basic" installation type for simplicity.
   - Follow the prompts to install. Note the instance name (default is MSSQLSERVER).
   - After installation, verify by opening Command Prompt and running `sqlcmd -S localhost -Q "SELECT @@VERSION;"`.

3. **Installation on macOS/Linux using Docker**:
   - Install Docker: [Docker Desktop](https://www.docker.com/products/docker-desktop).
   - Pull the SQL Server image: Open terminal and run `docker pull mcr.microsoft.com/mssql/server:2022-latest`.
   - Run the container: `docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrongPassword123!" -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest`.
   - Connect using `sqlcmd` or a client tool (install sqlcmd via package manager if needed).

**Tip**: Replace `YourStrongPassword123!` with a secure password. It must meet complexity requirements (at least 8 characters, uppercase, lowercase, number, symbol).

### Setting Up a Management Tool
- **SQL Server Management Studio (SSMS)**: For Windows users. Download from [SSMS Download](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms).
- **Azure Data Studio**: Cross-platform alternative. Download from [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio).
- Install and connect to your server using `localhost` (or container name in Docker) and SA credentials.

**Common Issues**:
- Firewall blocking port 1433? Add an exception.
- Forgot SA password? For Docker, stop and recreate the container.
- Resources: [Official Installation Guide](https://docs.microsoft.com/en-us/sql/sql-server/install/planning-a-sql-server-installation).

## Topics

This section is organized by progressing difficulty levels. Start here after setup!

## Basics

To begin working with SQL Server, create a dedicated database:

```sql
CREATE DATABASE LearningDB;
GO
USE LearningDB;
GO
```
### Explaination
CREATE DATABASE creates a new database.
GO is a batch separator (used in SSMS/Azure Data Studio).
USE switches the context to the new database.

Best Practice: Always work in a dedicated database to avoid cluttering master.
## Creating Tables

Tables store data in structured format. Below are the customers and orders table definitions.

1. customers Table
```sql
CREATE TABLE customers (
    id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    country VARCHAR(50),
    score INT,
    CONSTRAINT pk_customers PRIMARY KEY (id)
);
```
### Column Explanation:
| Column      | Type                | Description                    |
|--------------|--------------------|--------------------------------|
| id           | INT NOT NULL        | Unique identifier              |
| first_name   | VARCHAR(50) NOT NULL| Customer's first name          |
| country      | VARCHAR(50)         | Country *(nullable)*           |
| score        | INT                 | Loyalty score *(nullable)*     |


2. Orders table
```sql
CREATE TABLE orders (
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    sales DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```
### Column Explanation:
| Column      | Type                  | Description                               |
|--------------|----------------------|-------------------------------------------|
| order_id     | INT NOT NULL          | Unique order number                       |
| customer_id  | INT NOT NULL          | Links to `customers.id`                   |
| order_date   | DATE NOT NULL         | Date of order                             |
| sales        | DECIMAL(10,2) NOT NULL| Sale amount *(up to 10 digits, 2 decimals)*|

**Constraints**:

FOREIGN KEY ensures customer_id exists in customers table.
Prevents orphaned orders.

**Potential Errors:**

Trying to insert into orders with non-existent customer_id → foreign key violation.
Using VARCHAR for numbers → poor performance and sorting issues.

**Best Practices:**

Always define PRIMARY KEY.
Use appropriate data types (DATE for dates, DECIMAL for money).
Add FOREIGN KEY constraints for data integrity.

3. Persons Table
```sql
/* Create a new table called persons
   with columns: id, person_name, birth_date, and phone */
CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
);
SELECT * FROM persons;
```
### Explanation:

person_name: Full name (up to 50 chars).
birth_date: Nullable (some may not provide).
phone: Required, stored as string to preserve formatting (e.g., +1 (555) 123-4567).
SELECT * verifies table creation.

## Modifying Table Structure (ALTER, DROP)
```sql
ALTER TABLE persons ADD email VARCHAR(50) NULL;
-- Then update later

-- Drop a column
ALTER TABLE persons
DROP COLUMN phone;
```
### Explaination
Adds email column. Cannot be NULL — existing rows will cause an error unless a default is added.

**Error**: Cannot add NOT NULL column without default to non-empty table.

DROP will Permanently remove phone column and all its data.

```sql
--Drop entire table
DROP TABLE persons;
```
**Warning**: Irreversible. All data and structure are deleted.

## Inserting Data (INSERT)

```sql
INSERT INTO customers (id, first_name, country, score)
VALUES
    (1, 'Maria', 'Germany', 350),
    (2, 'John', 'USA', 900),
    (3, 'Georg', 'UK', 750),
    (4, 'Martin', 'Germany', 500);

INSERT INTO orders (order_id, customer_id, order_date, sales)
VALUES
    (1001, 1, '2021-01-11', 35.00),
    (1002, 2, '2021-04-05', 15.00),
    (1003, 3, '2021-06-18', 20.00);
```
### Explaiantion
Inserts 4 rows into customers.
Column list must match value order.
NULL can be used explicitly.
**Best Practice**: Always specify column names for clarity and safety.

### Copying Data Between Tables
```sql
INSERT INTO persons (id, person_name, birth_date, phone)
SELECT 
    id,
    first_name,
    NULL,
    'Unknown'
FROM customers;
```
### Explaination

Copies id and first_name from customers into persons.
Maps first_name → person_name.
Sets birth_date = NULL, phone = 'Unknown'.
Useful for transforming or migrating data.

## Update Data
```sql
UPDATE customers
SET score = 0
WHERE id = 6;
------------------------
UPDATE customers
SET score = 0, country = 'UK'
WHERE id = 7;
------------------------
UPDATE customers
SET score = 0
WHERE score IS NULL;
------------------------
```
### Explaination
Sets score = 0 for customer with id = 6.
Updates multiple columns in one statement.
Replaces all NULL scores with 0.
Use IS NULL, not = NULL.
**Best Practice:** Always use WHERE to avoid updating all rows.

## Deleting Data (DELETE)
```sql
DELETE FROM customers
WHERE score < 10;
```
### Explanation:

Removes rows where score < 10.
Only data is deleted; table structure remains.
**Difference from DROP TABLE:** DELETE removes rows, DROP removes table.

## Truncating Tables (TRUNCATE)
```sql
TRUNCATE TABLE persons;
```
### Explanation:

Removes all rows instantly.
Faster than DELETE (no logging per row).
Cannot use WHERE.
Resets identity counters (if any).
**Use Case:** Quickly clear test data.

## Querying Data
### Basic Aggregation: COUNT, SUM, AVG, MAX, MIN

```sql
-- Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;
----------------------------------------------
-- Total sales, average, max, min
SELECT
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    AVG(sales) AS average_sales,
    MAX(sales) AS highest_sales,
    MIN(sales) AS lowest_sales
FROM orders;
```
### Explanation:
COUNT(*): Counts all rows.
SUM(sales): Adds up all sales.
AVG(sales): Average of sales (automatically excludes NULL).
MAX / MIN: Highest and lowest values.

### Grouping Results with GROUP BY
```sql
-- Total sales per customer
-- Total sales per customer
SELECT
    customer_id,
    COUNT(*) AS order_count,
    SUM(sales) AS total_spent
FROM orders
GROUP BY customer_id;
```
### Explanation:

All non-aggregated columns in SELECT must appear in GROUP BY.
Each group gets one row with aggregated stats.

### Filtering Groups (HAVING)
Filters groups based on aggregate conditions. Use HAVING instead of WHERE for aggregates.
```sql
-- Customers with more than 1 order
SELECT
    customer_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
```
**Output**: (No rows — all customers have 1 order)
### Explanation:
HAVING applies after GROUP BY.
WHERE filters individual rows before grouping.

### Sorting Results (ORDER BY)
Sorts the result set by one or more columns.
```sql
-- Customers with more than 1 order
-- Orders sorted by sales (descending)
SELECT order_id, sales
FROM orders
ORDER BY sales DESC;
```
### Explanation:
ASC (default): Ascending
DESC: Descending
Can sort by multiple columns: ORDER BY country, score DESC

## Set Operators: EXCEPT, INTERSECT, UNION
```sql
-- Employees who are NOT customers
SELECT FirstName, LastName FROM Sales.Employees
EXCEPT
SELECT FirstName, LastName FROM Sales.Customers;
----------------------------------------------------------------
-- People who are both employees AND customers
SELECT FirstName, LastName FROM Sales.Employees
INTERSECT
SELECT FirstName, LastName FROM Sales.Customers;
----------------------------------------------------------------
SELECT FirstName, LastName FROM Sales.Customers
UNION ALL
SELECT FirstName, LastName FROM Sales.Employees;
```
### Explaination
UNION ALL: Includes all rows, including duplicates.
UNION: Removes duplicates (slower).
Column count and data types must match.
EXCEPT: Rows in first query not in second.
INTERSECT: Rows in both queries.
Automatically removes duplicates.

### String Functions
```sql
SELECT 
    TRIM(UPPER(first_name)) AS cleaned_name,
    LEN(TRIM(first_name)) AS name_length,
    LOWER(country) AS lower_country,
    CONCAT(first_name, ' ', country) AS full_info
FROM customers;
```
| Function          | Purpose                          |
|-------------------|----------------------------------|
| `TRIM()`          | Removes leading/trailing spaces  |
| `UPPER()` / `LOWER()` | Converts text to upper/lower case |
| `LEN()`           | Returns length of a string       |
| `CONCAT()`        | Joins multiple strings together  |


```sql
SELECT 
    '523-111-321-333' AS phone,
    REPLACE('523-111-321-333', '-', '') AS clean_phone;
-- Output: 523111321333

------------------------------------------------------

SELECT 
    first_name,
    LEFT(TRIM(first_name), 2) AS first_two,
    RIGHT(TRIM(first_name), 2) AS last_two,
    SUBSTRING(TRIM(first_name), 2, 4) AS middle_four
FROM customers;

```
### Numeric Functions
```sql
SELECT 
    3.516 AS original,
    ROUND(3.516, 2) AS rounded;  -- 3.52

SELECT 
    -3.516 AS original,
    ABS(-3.516) AS absolute;     -- 3.516
```

### Date & Time Functions
```sql
USE SalesDB;

SELECT 
    OrderID, OrderDate, ShipDate, CreationTime,
    DATETRUNC(day, CreationTime) AS day_start,
    DATETRUNC(minute, CreationTime) AS minute_start,
    DATEPART(year, CreationTime) AS year_part,
    DATENAME(weekday, CreationTime) AS day_name,
    EOMONTH(CreationTime) AS end_of_month,
    GETDATE() AS current_time
FROM Sales.Orders;
```
| Function              | Example Output         |
|------------------------|------------------------|
| `DATETRUNC(day, …)`    | 2025-08-20 00:00:00     |
| `DATEPART(month, …)`   | 8                      |
| `DATENAME(month, …)`   | August                 |
| `EOMONTH()`            | Last day of month      |

### Date Arithmetic: DATEADD, DATEDIFF
```sql
SELECT 
    OrderID, OrderDate, ShipDate,
    DATEADD(month, 3, OrderDate) AS plus_3_months,
    DATEDIFF(day, OrderDate, ShipDate) AS shipping_days
FROM Sales.Orders;
-------------------------------------------------------
-- Age of employee
SELECT 
    EmployeeID, BirthDate,
    DATEDIFF(year, BirthDate, GETDATE()) AS age
FROM Sales.Employees;
```

### Conditional Logic: CASE Expression
```sql
SELECT 
    OrderID, Sales,
    CASE
        WHEN Sales > 50 THEN 'High'
        WHEN Sales > 20 THEN 'Medium'
        ELSE 'Low'
    END AS Category
FROM Sales.Orders;
------------------------------------------------------------------
-- Map country codes
SELECT 
    CustomerID, Country,
    CASE Country
        WHEN 'Germany' THEN 'DE'
        WHEN 'USA' THEN 'US'
        ELSE 'N/A'
    END AS CountryCode
FROM Sales.Customers;
```

### NULL Handling: ISNULL
```sql
-- Average score, treat NULL as 0
SELECT
    CustomerID,
    LastName,
    Score,
    AVG(ISNULL(Score, 0)) OVER () AS AvgScore
FROM Sales.Customers;
```

### Validation: ISDATE
```sql
SELECT
    OrderDate,
    ISDATE(OrderDate) AS IsValidDate,
    CASE 
        WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
        ELSE '9999-09-09'
    END AS CleanDate
FROM (
    SELECT '2025-08-20' AS OrderDate UNION ALL
    SELECT '2025-08' UNION ALL
    SELECT 'invalid'
) t;
```

### Data Type Conversion: CAST, CONVERT
```sql
SSELECT
    CONVERT(INT, '123') AS int_val,
    CONVERT(DATE, '2025-04-22') AS date_val;
```

### Formatting Dates: FORMAT
```sql
SELECT 
    CreationTime,
    FORMAT(CreationTime, 'MM-dd-yyyy') AS usa_format,
    FORMAT(CreationTime, 'ddd MMM yyyy hh:mm tt') AS custom
FROM Sales.Orders;
```

### Aggregating with CASE
```sql
-- Count high-value orders per customer
SELECT
    CustomerID,
    SUM(CASE WHEN Sales > 30 THEN 1 ELSE 0 END) AS HighValueOrders,
    COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY CustomerID;
```

## Intermediate

### Joins & Relationships
#### Pattern Matching with LIKE

```sql
USE MyDatabase;
SELECT * 
FROM customers
WHERE first_name LIKE '__r%';
```
### Explaination
_ = exactly one character
% = zero or more characters
'__r%' = names with 3rd letter 'r' (e.g., Maria, Georg)

| Pattern | Matches        |
|----------|----------------|
| `J%`     | John, Julia    |
| `%a`     | Maria, Anna    |
| `_a%`    | Maria, Sam     |

### INNER JOIN
Returns only matching rows from both tables.
```sql
SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;
```
### Explanation:

Only customers with orders appear.
Use aliases (c, o) for readability.
ON specifies the join condition.

### LEFT JOIN
Returns all rows from left table, and matched rows from right.
Non-matching right rows → NULL.

```sql
SELECT * 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id;
```
**Use Case**: Show all customers, even those without orders.

### RIGHT JOIN
Opposite of LEFT JOIN — all rows from right table.
```sql
SELECT * 
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id;
```
Rarely used — prefer LEFT JOIN + swap table order.

### FULL OUTER JOIN
Returns all rows from both tables.
Non-matching rows filled with NULL.
```sql
SELECT * 
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id;
```

### Anti Joins (Non-Matching Rows)

#### LEFT ANTI JOIN
Customers who have not placed any order:
```sql
SELECT * 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL;
```
#### RIGHT ANTI JOIN
Orders without a valid customer (orphaned):
```sql
SELECT * 
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL;
```

#### FULL ANTI JOIN
Rows that don’t match in either table:
```sql
SELECT * 
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL;
```

#### Only Matching Rows (Alternative to INNER JOIN)
```sql
SELECT * 
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;
```
Same result as INNER JOIN, but using LEFT JOIN + WHERE.

### CROSS JOIN
Cartesian product — every row from left × every row from right.
```sql
SELECT * 
FROM customers AS c
CROSS JOIN orders AS o;
```
**Result**: If 4 customers × 3 orders = 12 rows
**Use Case**: Generate combinations (e.g., test data).

### Multiple Table Joins
```sql
USE SalesDB;
SELECT 
    o.OrderID,
    o.Sales,
    c.FirstName + ' ' + c.LastName AS Customer,
    p.Product AS ProductName,
    p.Price,
    e.FirstName + ' ' + e.LastName AS Employee
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e ON o.SalesPersonID = e.EmployeeID;
```
### Explanation:
Chain multiple JOINs.
Use LEFT JOIN to include orders even if customer/employee/product missing.
Build denormalized views for reporting.

## WINDOW FUNCTIONS
> **Window functions** perform calculations **across a set of rows** related to the current row, **without collapsing** the result like `GROUP BY`.

#### SUM() OVER() - Total & Partitioned Totals
```sql
```sql
-- GROUP BY: One row per group
SELECT ProductID, SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY ProductID;

-- WINDOW: Keep all rows + add aggregated value
SELECT 
    OrderID,
    ProductID,
    Sales,
    SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders;
```
| Feature                  | GROUP BY               | WINDOW                  |
|---------------------------|------------------------|--------------------------|
| Behavior                  | Collapses rows         | Keeps all rows           |
| Result type               | One result per group   | Adds column per row      |

### KEY SYNTAX
```sql
FUNCTION() OVER(
    [PARTITION BY col1, col2]   -- Optional: group rows
    [ORDER BY col]              -- Required for ranking/running totals
    [ROWS/RANGE frame]          -- Optional: limit rows in calculation
)
```
**Explanation**:
OVER() → entire result set
PARTITION BY → groups like GROUP BY, but keeps all rows

### SUM() OVER() — Running & Partition Totals
```sql
SELECT
    OrderID,
    ProductID,
    Sales,
    SUM(Sales) OVER() AS GrandTotal,
    SUM(Sales) OVER(PARTITION BY ProductID) AS TotalPerProduct
FROM Sales.Orders;
```
```sql
-- Total sales by Product + OrderStatus
SELECT
    ProductID,
    OrderStatus,
    OrderID,
    Sales,
    SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS TotalByProdAndStatus
FROM Sales.Orders;
```
### Explaination
SUM(Sales) OVER() → entire result set.
PARTITION BY ProductID → resets total for each product.
Multiple columns in PARTITION BY → finer grouping.

### AVG(), MAX(), MIN() OVER()
```sql
SELECT 
    OrderID,
    ProductID,
    Sales,
    AVG(Sales) OVER(PARTITION BY ProductID) AS AvgPerProduct,
    MAX(Sales) OVER(PARTITION BY ProductID) AS MaxPerProduct,
    MIN(Sales) OVER(PARTITION BY ProductID) AS MinPerProduct
FROM Sales.Orders;
```
### RANK(), DENSE_RANK(), ROW_NUMBER()
| Function       | Gaps? | Same Value       |
|----------------|-------|------------------|
| `ROW_NUMBER()` | No    | Unique           |
| `RANK()`       | Yes   | Same → gap       |
| `DENSE_RANK()` | No    | Same → no gap    |

```sql
SELECT
    OrderID,
    Sales,
    ROW_NUMBER() OVER(ORDER BY Sales DESC) AS rn,
    RANK() OVER(ORDER BY Sales DESC) AS rank_gap,
    DENSE_RANK() OVER(ORDER BY Sales DESC) AS dense_no_gap
FROM Sales.Orders;
```
**EXAMPLE OUTPUT**
| Sales | ROW_NUMBER() | RANK() (gap) | DENSE_RANK() (no gap) |
|--------|---------------|--------------|------------------------|
| 100    | 1             | 1            | 1                      |
| 90     | 2             | 2            | 2                      |
| 90     | 3             | 2            | 2                      |
| 80     | 4             | 4            | 3                      |

### NTILE() — Bucketing Data 
Divides rows into N equal-sized buckets.
```sql
SELECT 
    OrderID,
    Sales,
    NTILE(4) OVER(ORDER BY Sales DESC) AS Quartile
FROM Sales.Orders;
```
**Use Case**: Segment customers into High/Medium/Low spenders:
Divides data into 4 equal-sized buckets.
1 = top 25%, 4 = bottom 25%.

```sql
SELECT *,
    CASE 
        WHEN Bucket = 1 THEN 'HIGH'
        WHEN Bucket = 2 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS Segment
FROM (
    SELECT OrderID, Sales, NTILE(3) OVER(ORDER BY Sales DESC) AS Bucket
    FROM Sales.Orders
) t;
```

### LAG() & LEAD() — Previous/Next Values
```sql
-- Month-over-month sales growth
SELECT 
    OrderMonth,
    CurrentSales,
    PrevSales,
    (CurrentSales - PrevSales) AS Diff,
    ROUND(CAST((CurrentSales - PrevSales) AS FLOAT) / NULLIF(PrevSales, 0) * 100, 2) AS PctChange
FROM (
    SELECT
        MONTH(OrderDate) AS OrderMonth,
        SUM(Sales) AS CurrentSales,
        LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) AS PrevSales
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
) t;
```
#### Explanation:
LAG(col, 1) → value from previous row.
NULLIF(PrevSales, 0) → avoid divide-by-zero.

```sql
-- Avg days between customer orders
SELECT 
    CustomerID,
    AVG(DaysBetween) AS AvgDaysBetweenOrders
FROM (
    SELECT
        CustomerID,
        OrderDate,
        LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrder,
        DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS DaysBetween
    FROM Sales.Orders
) t
WHERE DaysBetween IS NOT NULL
GROUP BY CustomerID;
```
#### Explanation:
LEAD(col, 1) → value from next row.

### FIRST_VALUE() & LAST_VALUE()
```sql
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS LowestInProduct,
    LAST_VALUE(Sales) OVER(
        PARTITION BY ProductID 
        ORDER BY Sales 
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS HighestInProduct
FROM Sales.Orders;
```
| Function | Purpose | Example | Notes |
|-----------|----------|----------|--------|
| `FIRST_VALUE(column)` | Returns the **first value** in the ordered window | `FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales)` | Gives the **lowest** sale per product (if ordered ascending) |
| `LAST_VALUE(column)` | Returns the **last value** in the ordered window | `LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)` | Gives the **highest** sale per product (when frame is extended) |

**Warning**: LAST_VALUE() without frame defaults to RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW → may not return expected last value.
**Fix**: Always specify frame for LAST_VALUE.

### CUME_DIST() - Cumulative Distribution
```sql
-- Top 40% most expensive products
SELECT * FROM (
    SELECT 
        Product,
        Price,
        CUME_DIST() OVER(ORDER BY Price DESC) AS DistRank
    FROM Sales.Products
) t
WHERE DistRank <= 0.4;
```
| Part | Code / Concept | Purpose | Notes |
|------|----------------|----------|-------|
| `CUME_DIST()` | `CUME_DIST() OVER(ORDER BY Price DESC)` | Calculates the **cumulative distribution** of prices | Returns a value between 0 and 1 |
| `ORDER BY Price DESC` | Sorts products from **highest to lowest** price | Ensures top-priced items get the smallest distribution values |
| Subquery alias `t` | Wraps results so we can filter on `DistRank` | Needed because window functions can't be filtered directly |
| `WHERE DistRank <= 0.4` | Keeps only rows in the **top 40%** of prices | Filters products by distribution rank |

### Window Frame Specification (ROWS BETWEEN)
```sql
-- Moving average: current + next 1 order
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER(
        PARTITION BY ProductID 
        ORDER BY OrderDate 
        ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
    ) AS MovingAvg_Next1
FROM Sales.Orders;
```
| Frame Clause           | Meaning                    |
|-------------------------|-----------------------------|
| `UNBOUNDED PRECEDING`   | From the **first row** in the partition |
| `CURRENT ROW`           | Only the **current row** |
| `1 FOLLOWING`           | The **next 1 row** |
| `UNBOUNDED FOLLOWING`   | Up to the **last row** in the partition |

### Practical Use Cases
```sql
1. Running Total
sqlSELECT
    OrderID,
    OrderDate,
    Sales,
    SUM(Sales) OVER(ORDER BY OrderDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM Sales.Orders;
-----------------------------------------------------------------------------------------------
2. % of Total Sales
sqlSELECT 
    OrderID,
    Sales,
    ROUND(Sales * 100.0 / SUM(Sales) OVER(), 2) AS PctOfTotal
FROM Sales.Orders;
-----------------------------------------------------------------------------------------------
3. Top 1 Sale per Product
sqlSELECT * FROM (
    SELECT 
        OrderID, ProductID, Sales,
        ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS rn
    FROM Sales.Orders
) t WHERE rn = 1;
-----------------------------------------------------------------------------------------------
4. Remove Duplicates
sql-- Keep latest by CreationTime
SELECT * FROM (
    SELECT 
        *, 
        ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn
    FROM Sales.OrdersArchive
) t WHERE rn = 1;
-----------------------------------------------------------------------------------------------
5. Identify Duplicates
sqlSELECT * FROM (
    SELECT 
        *, 
        COUNT(*) OVER(PARTITION BY OrderID) AS dup_count
    FROM Sales.OrdersArchive
) t WHERE dup_count > 1;
```
### NULL Handling and Safety
> **NULL** represents **unknown or missing data**. It’s **not zero**, **not empty string**, and **does not equal anything** — even itself!

#### COALESCE() — First Non-NULL Value
```sql
SELECT
    CustomerID,
    Score,
    COALESCE(Score, 0) AS ScoreWithZero,
    AVG(Score) OVER() AS AvgScore_WithNULLs,
    AVG(COALESCE(Score, 0)) OVER() AS AvgScore_WithZero
FROM Sales.Customers;
```
### Explanation:

COALESCE(Score, 0) → returns Score if not NULL, else 0.
AVG(Score) → excludes NULLs from calculation.
AVG(COALESCE(Score, 0)) → includes NULLs as 0, lowering average.
**Best Practice**: Use COALESCE when you want to replace NULLs with a meaningful default.

#### ISNULL() — Replace NULL (SQL Server Specific)
```sql
SELECT 
    CustomerID,
    FirstName,
    LastName,
    ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') AS FullName,
    Score,
    ISNULL(Score, 0) + 10 AS BonusScore
FROM Sales.Customers;
```
### Explanation:

ISNULL(expr, replacement) → SQL Server-specific, faster than COALESCE.
Safely concatenates names even if one is NULL.
Adds 10 bonus points, treating NULL as 0.
**Note**: ISNULL takes exactly 2 arguments; COALESCE takes multiple.

#### NULLIF() — Avoid Divide-by-Zero
```sql
SELECT
    OrderID,
    Sales,
    Quantity,
    Sales / NULLIF(Quantity, 0) AS UnitPrice
FROM Sales.Orders;
```
### Explanation:

NULLIF(Quantity, 0) → returns NULL if Quantity = 0, else Quantity.
Prevents divide-by-zero error → result becomes NULL instead.

### Sorting & Filtering with NULLs
```sql
-- Sort: NULLs last (highest score first)
SELECT 
    CustomerID,
    Score,
    COALESCE(Score, 999999999) AS SortKey
FROM Sales.Customers
ORDER BY COALESCE(Score, 999999999);
```
### Explanation:

ORDER BY Score → NULLs appear first (treated as lowest).
COALESCE(Score, 999999999) → forces NULLs to sort last.

## Advanced

## CTEs (Common Table Expressions)
###W hat is a CTE?
**CTE** stands for **Common Table Expression**.

> A **temporary named result set** that you can reference within a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement.  
> Think of it as a **temporary view** that exists **only during the execution of the query**.

#### Syntax
```sql
WITH CTE_Name (column1, column2, ...)
AS
(
    -- Your query here
    SELECT ...
    FROM ...
)
-- Main query (can reference CTE)
SELECT * FROM CTE_Name;
```
Starts with WITH.
Name followed by optional column list.
AS (query).
Semicolon (;) before WITH if previous statement exists.
Can define multiple CTEs separated by commas.

#### Why Use CTEs?
| Problem | Solved by CTE |
|----------|----------------|
| Complex, unreadable queries | Break into logical steps |
| Repeated subqueries | Define once, reuse |
| Hierarchical data (org charts, BOM) | Recursive traversal |
| Cleaner alternative to derived tables | More readable than `(SELECT …)` in `FROM` |

#### Advantages & Disadvantages
| Advantages | Disadvantages |
|-------------|----------------|
| Improves readability | Not stored permanently |
| Can be referenced multiple times | Performance same as subquery (sometimes slower) |
| Supports recursion | `MAXRECURSION` limit (default 100) |
| Great for step-by-step logic | Cannot be nested beyond query scope |

#### Types of CTEs
| Type | Description |
|-------|--------------|
| Non-Recursive | Standard CTE — no self-reference |
| Recursive | CTE that references itself — used for hierarchies |

### Non-Recursive CTEs

#### Standalone CTE
One CTE, used once; Clean, reusable logic.
```sql
WITH CTE_TotalSales AS (
    SELECT CustomerID, SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
SELECT c.FirstName, c.LastName, ISNULL(cte.TotalSales, 0) AS Sales
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cte ON c.CustomerID = cte.CustomerID;
```
#### Nested (Chained) CTEs
```sql
WITH 
CTE_TotalSales AS (
    SELECT CustomerID, SUM(Sales) AS totalSales
    FROM Sales.Orders
    GROUP BY CustomerID
),
CTE_LastOrder AS (
    SELECT CustomerID, MAX(OrderDate) AS LastOrder
    FROM Sales.Orders
    GROUP BY CustomerID
),
CTE_CustomerRank AS (
    SELECT CustomerID, totalSales,
           RANK() OVER(ORDER BY totalSales DESC) AS CustomerRank
    FROM CTE_TotalSales
),
CTE_CustomerSegment AS (
    SELECT CustomerID,
           CASE 
               WHEN totalSales > 100 THEN 'High'
               WHEN totalSales > 50 THEN 'Medium'
               ELSE 'Low'
           END AS CustomerSegment
    FROM CTE_TotalSales
)
-- Main Query
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    ISNULL(cts.totalSales, 0) AS TotalSales,
    cts2.LastOrder,
    cts3.CustomerRank,
    cts4.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_LastOrder cts2 ON cts2.CustomerID = c.CustomerID
LEFT JOIN CTE_CustomerRank cts3 ON cts3.CustomerID = c.CustomerID
LEFT JOIN CTE_CustomerSegment cts4 ON cts4.CustomerID = c.CustomerID;
```
#### Explaination
4 CTEs defined in sequence.
Each builds on the previous.
Final SELECT joins all insights.
Modular, readable, reusable.

### Recursive CTEs
Used for hierarchical or sequential data.
```sql
WITH CTE_Name AS (
    -- Anchor: Starting point
    SELECT ...
    UNION ALL
    -- Recursive part: References CTE_Name
    SELECT ...
    FROM CTE_Name ...
)
```
**Generate Sequence (1 to 20)**
```sql
;WITH Series AS (
    -- Anchor: Start with 1
    SELECT 1 AS MyNumber
    UNION ALL
    -- Recursive: Add 1, stop at 20
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 20
)
SELECT * FROM Series
OPTION (MAXRECURSION 20);
```
**Employee Hierarchy**
```sql
;WITH CTE_EmpHierarchy AS (
    -- Anchor: Top-level employees (no manager)
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive: Employees under above
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        ceh.Level + 1
    FROM Sales.Employees AS e
    INNER JOIN CTE_EmpHierarchy ceh
        ON e.ManagerID = ceh.EmployeeID
)
SELECT * FROM CTE_EmpHierarchy
OPTION (MAXRECURSION 100);
```
| EmployeeID | FirstName | LastName | Level |
|-------------|------------|-----------|--------|
| 1 | John | CEO | 1 |
| 2 | Jane | Manager | 2 |
| 3 | Bob | Analyst | 3 |

#### Explaination
Anchor: CEOs (ManagerID IS NULL)
Recursive: Find direct reports → their reports → etc.
Level increments per level

### Best Practices & Tips
| Tip | Why |
|------|------|
| Always end previous statement with `;` | Avoids `WITH` confusion |
| Use meaningful CTE names | `"CTE_SalesByRegion"`, not `CTE1` |
| Limit recursion with `OPTION (MAXRECURSION n)` | Prevent infinite loops |
| CTEs are not indexed | Don’t expect performance boost |
| Use for logic clarity, not performance | Same execution plan as subqueries |

## Views
> A **View** is a **virtual table** based on the result of a `SELECT` query.  
> It **does not store data physically** (except indexed views), but **presents data** as if it were a real table.
Think of it as a **saved query** you can reuse like a table.

#### Syntax

```sql
CREATE VIEW [schema_name.]view_name AS
SELECT column1, column2, ...
FROM table1
JOIN table2 ON ...
WHERE condition;

-- Alter existing view
ALTER VIEW view_name AS ...

-- Drop view
DROP VIEW IF EXISTS view_name;
```
### Why Use Views?
| Use Case | Solved by View |
|-----------|----------------|
| Complex joins every time | Save once, reuse |
| Hide sensitive columns | Show only needed data |
| Simplify reporting | Pre-aggregated summaries |
| Enforce business logic | Consistent calculations |
| Security & access control | Grant access to view, not base tables |

### Advantages & Disadvantages
| Advantages | Disadvantages |
|-------------|----------------|
| Reusable queries | No physical data → can be slow |
| Security (column/table masking) | Cannot use ORDER BY without TOP |
| Simplify complex logic | Updates limited (single table, no aggregates) |
| Logical abstraction | Not all views are updatable |
| Can be indexed (materialized) | Extra object to manage |

### Types of Views
| Type | Description |
|-------|-------------|
| Simple View | Based on one table, updatable |
| Complex View | Joins, aggregates — not updatable |
| Indexed (Materialized) View | Physically stores data — fast reads |
| Partitioned View | Combines tables across servers |

### Creating & Managing Views
Safe Drop + Create
```sql
IF OBJECT_ID('Sales.Monthly_summaryy', 'V') IS NOT NULL
    DROP VIEW Sales.Monthly_summaryy;
GO

CREATE VIEW Sales.Monthly_summaryy AS
SELECT
    DATETRUNC(month, OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders,
    SUM(Quantity) AS TotalQuantities
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate);
GO
```
### Explanation:
OBJECT_ID(..., 'V') → checks if view exists.
GO → batch separator (required after DROP).
View now acts like a summary table.

**Business Views for Teams**
```sql
CREATE VIEW Sales.OrderDetails AS
SELECT
    o.OrderID,
    o.OrderDate,
    o.Sales,
    p.Product,
    p.Category,
    COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
    COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS EmployeeName,
    c.Country AS CustomerCountry,
    o.Quantity
FROM Sales.Orders o
LEFT JOIN Sales.Products p ON p.ProductID = o.ProductID
LEFT JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees e ON e.EmployeeID = o.SalesPersonID
WHERE c.Country != 'USA';  -- EU Sales Team only
```
### Explaination
Combines 4 tables into one clean view.
Excludes USA data → tailored for EU team.
COALESCE prevents NULL in names.
Now EU analysts query Sales.OrderDetails directly.

### Best Practices & Security
| Practice | Why |
|-----------|-----|
| Use schema (e.g., Sales.) | Organize & secure |
| Avoid SELECT * | Explicit columns = future-proof |
| Add WITH SCHEMABINDING | For indexed views |
| Grant SELECT on view, not tables | Least privilege |
| Document purpose in comments | Team clarity |

```sql
-- Example: Secure access
GRANT SELECT ON Sales.OrderDetails TO EU_Sales_Team;
-- Deny access to base tables if needed
```
## Tables: Permanent vs Temporary
> **Temporary tables** are **short-lived tables** used to store **intermediate results** during query execution.  
> They behave like regular tables but are **automatically dropped** when the session ends.

#### Types of Temporary Tables

| Type | Name Prefix | Scope | Stored In |
|------|-------------|-------|-----------|
| **Local Temp Table** | `#TableName` | Current session only | `tempdb` |
| **Global Temp Table** | `##TableName` | All sessions | `tempdb` |

#### Syntax & Naming
```sql
-- Local temp table
CREATE TABLE #TempOrders (OrderID INT, Sales DECIMAL(10,2));

-- Global temp table
CREATE TABLE ##GlobalTemp (ID INT);
```
'#'→ Local (visible only to your connection).
'##' → Global (visible to all connections).
Stored in tempdb database

### Why Use Temp Tables?
| Scenario | Solved by Temp Table |
|-----------|----------------------|
| Complex multi-step logic | Store intermediate results |
| Performance tuning | Break query into parts |
| Debugging | Inspect data mid-query |
| Reuse in stored procedures | Pass data between steps |

### Advantages & Disadvantages
| Advantages | Disadvantages |
|-------------|----------------|
| Full table features (indexes, stats) | Uses tempdb → can cause contention |
| Can be indexed | Automatically dropped → not persistent |
| Survive beyond CTE scope | Name collisions in multi-user |
| Great for large intermediate data | Manual cleanup needed if global |

#### CTAS: Create Table As SELECT
```sql
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
    DROP TABLE Sales.MonthlyOrders;
GO

SELECT 
    DATENAME(month, OrderDate) AS OrderMonth,
    COUNT(OrderID) AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

SELECT * FROM Sales.MonthlyOrders;
```
### Explanation:
SELECT ... INTO → creates and populates a new table.
IF OBJECT_ID(..., 'U') → 'U' = user table.
Creates permanent table Sales.MonthlyOrders.

### Working with Temp Tables
```sql
-- Step 1: Create temp table from Orders
SELECT * 
INTO #OrderTemp
FROM Sales.Orders;

-- Step 2: Modify temp data
DELETE FROM #OrderTemp
WHERE OrderStatus = 'Delivered';

-- Step 3: View filtered data
SELECT * FROM #OrderTemp;

-- Step 4: Copy to permanent table
SELECT * 
INTO Sales.OrderTest
FROM #OrderTemp;
```
**Step-by-Step Explanation:**
1. SELECT * INTO #OrderTemp
→ Creates local temp table #OrderTemp with all Orders data.
2. DELETE FROM #OrderTemp WHERE ...
→ Removes delivered orders only from temp table.
3. SELECT * FROM #OrderTemp
→ Shows filtered, in-memory version.
4. SELECT * INTO Sales.OrderTest
→ Saves final result to permanent table.
**Note**: #OrderTemp is automatically dropped when your SSMS tab closes.

### Scope & LifeTime
| Table Type | Created | Dropped |
|-------------|----------|----------|
| #LocalTemp | On first reference | When session ends |
| ##GlobalTemp | On first reference | When last session using it ends |
| Permanent | On CREATE TABLE | On DROP TABLE |

```sql
-- Check temp tables in current session
SELECT * FROM tempdb.sys.tables WHERE name LIKE '#%';
```
### Best Practices
| Practice | Why |
|-----------|-----|
| Use IF OBJECT_ID(...) DROP TABLE | Avoid "already exists" error |
| Prefer #Local over ##Global | Avoid conflicts |
| Add indexes on large temp tables | Speed up joins |
| Don't overuse | tempdb is shared resource |
| Use CTAS for one-time exports | Clean & fast |

```sql
-- Add index to temp table
CREATE CLUSTERED INDEX IX_OrderTemp_Customer ON #OrderTemp(CustomerID);
```

### Database Automation: Triggers
#### What is a Trigger?
> A **Trigger** is a **special type of stored procedure** that **automatically executes** in response to **specific events** on a table or view.
> Think of it as an **event-driven rule** — "When X happens, do Y".

#### Types of Triggers

| Type | Event | Example |
|------|-------|--------|
| **DML Triggers** | `INSERT`, `UPDATE`, `DELETE` | Log changes |
| **DDL Triggers** | `CREATE`, `ALTER`, `DROP` | Prevent schema changes |
| **Logon Triggers** | User login | Audit logins |

#### DML Triggers: AFTER vs INSTEAD OF

| Type | When It Runs | Use Case |
|------|--------------|--------|
| **AFTER** | **After** the event completes | Audit, logging |
| **INSTEAD OF** | **Instead of** the event | Modify behavior (e.g., views) |

#### Special Tables: INSERTED & DELETED

| Table | Contains |
|-------|---------|
| `INSERTED` | New rows (for `INSERT` and `UPDATE`) |
| `DELETED` | Old rows (for `DELETE` and `UPDATE`) |

> Both are **in-memory tables** in `tempdb`.

#### Why Use Triggers?

| Scenario | Solved by Trigger |
|--------|------------------|
| Audit trail | Auto-log every change |
| Data validation | Enforce complex rules |
| Sync related tables | Auto-update child records |
| Prevent invalid data | Rollback bad inserts |

#### Advantages & Disadvantages

| **Advantages** | **Disadvantages** |
|----------------|-------------------|
| Automatic enforcement | Hidden logic → hard to debug |
| No app changes needed | Performance overhead |
| Centralized rules | Can cause recursive triggers |
| Great for auditing | Not visible in app code |

```sql
-- Step 1: Create audit log table
CREATE TABLE Sales.EmployeeLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate DATE
);
``sql
-- Step 2: Create AFTER INSERT trigger
CREATE TRIGGER trg_AfterInsertEmployee 
ON Sales.Employees
AFTER INSERT
AS 
BEGIN
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT 
        EmployeeID,
        'New Employee Added = ' + CAST(EmployeeID AS VARCHAR(10)),
        CAST(GETDATE() AS DATE)
    FROM INSERTED;
END;
```
### Explanation:
INSERT fires → data goes to INSERTED table.
Trigger runs → reads from INSERTED.
Inserts audit record into EmployeeLogs.

### Best Practices & Warnings
| Practice | Why |
|-----------|-----|
| Keep logic simple | Avoid long-running triggers |
| Use SET NOCOUNT ON | Prevent extra result sets |
| Avoid SELECT in triggers | Can confuse apps |
| Test with multiple rows | Triggers fire once per statement |
| Disable if needed | DISABLE TRIGGER trg_name ON table |

```sql
-- Safe trigger template
CREATE TRIGGER trg_Safe 
ON TableName
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM INSERTED)
    BEGIN
        -- Your logic
    END
END
```

### MULTIPLE EVENTS
```sql
CREATE TRIGGER trg_EmployeeAudit
ON Sales.Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Log inserts
    IF EXISTS (SELECT 1 FROM INSERTED) AND NOT EXISTS (SELECT 1 FROM DELETED)
        INSERT INTO Sales.EmployeeLogs (...)
        SELECT ..., 'Inserted', ... FROM INSERTED;

    -- Log updates
    IF EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
        INSERT INTO Sales.EmployeeLogs (...)
        SELECT ..., 'Updated', ... FROM INSERTED;

    -- Log deletes
    IF EXISTS (SELECT 1 FROM DELETED) AND NOT EXISTS (SELECT 1 FROM INSERTED)
        INSERT INTO Sales.EmployeeLogs (...)
        SELECT ..., 'Deleted', ... FROM DELETED;
END
```

## Stored Procedures: Reusable Logic
>A **Stored Procedure** is a **pre-compiled, reusable batch of T-SQL code** stored in the database.  
> It can accept **input parameters**, return **results**, and perform **complex operations**.
> Think of it as a **function** in programming — call it with inputs, get outputs.

```sql
CREATE PROCEDURE [schema.]procedure_name
    @parameter1 datatype = default_value,
    @parameter2 datatype OUTPUT
AS
BEGIN
    -- Your logic here
END
```
-CREATE PROCEDURE → define
-ALTER PROCEDURE → modify
-DROP PROCEDURE IF EXISTS → safe delete
-EXEC procedure_name @param = value

### Why Use Stored Procedures?
| Use Case | Solved by Procedure |
|-----------|---------------------|
| Repeated complex logic | Save once, reuse |
| Security | Grant EXEC only |
| Performance | Pre-compiled plan |
| Encapsulation | Hide implementation |
| Maintenance | Change in one place |

### Advantages & Disadvantages
| Advantages | Disadvantages |
|------------|--------------|
| Reusable & centralized | Harder to version control |
| Faster execution (cached plan) | Debugging is tricky |
| Reduced network traffic | Vendor lock-in |
| Security via EXEC permissions | Overuse hurts clarity |

### Parameters: Input & Output
```sql
@Country NVARCHAR(50) = 'USA'  -- Input with default
@TotalSales DECIMAL(18,2) OUTPUT  -- Output parameter
```
@ → parameter prefix.
= default → optional.
OUTPUT → returns value to caller.

### Variables: Local Storage
```sql
DECLARE @TotalCustomers INT;
SET @TotalCustomers = 100;
```
@ → variable.
DECLARE → create.
SET or SELECT → assign.

### Control Flow: IF...ELSE
```sql
IF EXISTS (SELECT 1 FROM ...)
BEGIN
    -- Do something
END
ELSE
BEGIN
    -- Do else
END
```
### Error Handling: TRY...CATCH
```sql
BEGIN TRY
    -- Risky code
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
```
### Best Practices
| Practice | Why |
|-----------|-----|
| Use schema (e.g., Sales.) | Organize |
| SET NOCOUNT ON | Avoid "n rows affected" |
| DROP PROC IF EXISTS | Safe re-creation |
| Use TRY...CATCH | Graceful errors |
| Validate inputs | Prevent bad data |

### Full Example: Dynamic Customer Report
```sql
DROP PROCEDURE IF EXISTS Sales.GetCustomerSummary;
GO

CREATE PROCEDURE Sales.GetCustomerSummary 
    @Country NVARCHAR(50) = 'USA'
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @TotalCustomers INT;
        DECLARE @AvgScore FLOAT;

        -- Step 1: Clean NULL scores
        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT 'Updating NULL scores to 0 for ' + @Country;
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END
        ELSE
        BEGIN
            PRINT 'No NULL scores found.';
        END

        -- Step 2: Calculate summary
        SELECT 
            @TotalCustomers = COUNT(*),
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        -- Step 3: Print summary
        PRINT 'Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR(10));
        PRINT 'Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR(20));

        -- Step 4: Orders report (with intentional error for demo)
        SELECT
            COUNT(o.OrderID) AS TotalOrders,
            SUM(o.Sales) AS TotalSales
            -- 1/0  -- Uncomment to trigger error
        FROM Sales.Orders o
        INNER JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;

    END TRY
    BEGIN CATCH
        PRINT 'AN ERROR OCCURRED!';
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
        PRINT 'ERROR PROCEDURE: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
    END CATCH
END
GO
```
### Execute the procedure
```sql
-- Default: USA
EXEC Sales.GetCustomerSummary;

-- Germany
EXEC Sales.GetCustomerSummary @Country = 'Germany';
```

## Performance Tuning: Indexes & Storage
> An **index** is a **database structure** that improves the **speed of data retrieval** operations on a table at the cost of **additional storage** and **slower writes**.
> Think of it like the **index in a book** — helps you find pages quickly without scanning everything.

#### HEAP vs CLUSTERED vs NONCLUSTERED

| Structure | Data Order | Max per Table | Storage |
|---------|------------|---------------|--------|
| **HEAP** | No order | N/A | Just data |
| **CLUSTERED** | **Physical order** | **1 only** | Data + index |
| **NONCLUSTERED** | Separate | Up to 999 | Pointers to data |

## CLUSTERED INDEX — Physical Order
> A **Clustered Index** determines the **physical order** of data in the table.

- Data rows are **stored in sorted order** based on the index key.
- The **table = the index** (data pages are index pages).
- **Only one** allowed per table.
- Usually on **Primary Key** (by default).

```sql
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)
```
**Before** : CustomerID: 5, 1, 8, 3
**After** : CustomerID: 1, 3, 5, 8  ← Physically reordered!

### Advantages & Disadvantages
| Advantages | Disadvantages |
|------------|--------------|
| Fast range scans (BETWEEN, >, <) | Slow inserts (page splits) |
| Fast ordered retrieval | Only one per table |
| No extra lookup | Rebuild on key changes |
| Ideal for PK lookups | Fragmentation over time |

### When to Use
| Scenario | Use Clustered Index |
|----------|---------------------|
| Primary Key (unique, sequential) | Yes |
| Frequent ORDER BY column | Yes |
| Range queries (Date BETWEEN ...) | Yes |
| Foreign key columns (joins) | Consider |

## NONCLUSTERED INDEX — Pointers
>A Nonclustered Index is a separate structure containing sorted key values + pointers to actual data.
>Like a phone book: Name → Page number.
>Data remains in original order (heap or clustered).
>Up to 999 per table.

```sql
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName);
```
```text
Index: Brown → RowID 5
       Smith  → RowID 1
```
### Advantages & Disadvantages
| Advantages | Disadvantages |
|------------|--------------|
| Multiple per table | Extra storage |
| Fast exact match (WHERE LastName = 'Brown') | Two lookups (index → data) |
| Can include columns (INCLUDE) | Slower writes |
| Great for foreign keys, filters | |

### When to Use
| Scenario | Use Non-Clustered Index |
|----------|-------------------------|
| Frequent WHERE filters | Yes |
| JOIN columns | Yes |
| GROUP BY, ORDER BY | Yes |
| Covering queries (INCLUDE) | Yes |

## COLUMNSTORE INDEX — Analytics Power

**Rowstore vs Columnstore**
| Storage | Layout | Best For |
|---------|--------|----------|
| Rowstore | Entire row together | OLTP (transactions) |
| Columnstore | One column together | OLAP (analytics) |

```text
Rowstore:     [ID:1, Name:John, Sales:100]
              [ID:2, Name:Jane, Sales:200]

Columnstore:  ID:   [1, 2]
              Name: [John, Jane]
              Sales:[100, 200]  ← Compressed!
```

### Clustered vs Nonclustered Columnstore
| Type | Description |
|------|-------------|
| Clustered Columnstore | Replaces all rowstore data — entire table |
| Nonclustered Columnstore | Add-on index — for specific queries |

```sql
-- Full analytics table
CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
ON FactInternetSales_CS;

-- Hybrid: keep rowstore + add analytics
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName);
```
### Practical Examples
```sql
-- 1. Copy data
SELECT * INTO Sales.DBCustomers FROM Sales.Customers;

-- 2. Add Clustered Index (PK-like)
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

-- 3. Add Nonclustered for filtering
CREATE NONCLUSTERED INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score);

-- 4. Query uses index!
SELECT * FROM Sales.DBCustomers 
WHERE Country = 'USA' AND Score > 50;
```
### Index Management
```sql
-- Drop index
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;

-- Rebuild fragmented index
ALTER INDEX idx_DBCustomers_CountryScore ON Sales.DBCustomers REBUILD;

-- View index usage
SELECT * FROM sys.dm_db_index_usage_stats 
WHERE object_id = OBJECT_ID('Sales.DBCustomers');
```

### Best Practices & Myths
| Do | Don't |
|----|-------|
| Index PK with clustered | Over-index (999 nonclustered = bad) |
| Index foreign keys | Index every column |
| Use INCLUDE for covering | Forget to rebuild after bulk load |
| Monitor sys.dm_db_index_usage_stats | Believe "indexes always help" |

```sql
-- Covering index (avoid lookup)
CREATE NONCLUSTERED INDEX idx_Covering
ON Sales.DBCustomers (Country)
INCLUDE (FirstName, LastName, Score);
```
#### UNIQUE & FILTERED Indexes

##### UNIQUE Index — Enforce Uniqueness

```sql
CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products (Product);
```
#### What Happens?
```sql
INSERT INTO Sales.Products (ProductID, Product) VALUES (106, 'Caps');
-- ERROR: Violation of UNIQUE KEY constraint
```
### Explanation:
Prevents duplicate values in Product column.
Can be clustered or nonclustered.
Automatically created on PRIMARY KEY.

### FILTERED Index — Index Only Specific Rows
```sql
CREATE NONCLUSTERED INDEX idx_Customers_USA
ON Sales.Customers (Country)
WHERE Country = 'USA';
```

**Benefits**:
Smaller index → faster
Only indexes USA customers
Ideal for sparse data (e.g., Status = 'Active')

### Index Management & Monitoring

**Monitor Index Usage (DMV)**
```sql
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    idx.type_desc AS IndexType,
    idx.is_primary_key,
    idx.is_unique,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates,
    COALESCE(s.last_user_seek, s.last_user_scan, s.last_user_lookup) AS LastUsed
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s 
    ON s.object_id = idx.object_id AND s.index_id = idx.index_id
WHERE s.database_id = DB_ID()
ORDER BY tbl.name, idx.name;
```
**Key Columns:**
-user_seeks → used in WHERE, JOIN
-user_scans → full scan (bad for large tables)
-user_updates → cost of writes
-LastUsed → when was it helpful?

##### Find Missing Indexes

```sql
SELECT * FROM sys.dm_db_missing_index_details;
```
**Output**:
| equality_columns | inequality_columns | included_columns | statement |
|------------------|--------------------|------------------|----------|
| Country          | Score              | FirstName, LastName | SELECT ... FROM Customers WHERE Country='USA' AND Score>50 |

**SQL Server says**: "Create this index!

##### Find Duplicate/Redundant Indexes

```sql
SELECT 
    tbl.name AS TableName,
    col.name AS ColumnName,
    STRING_AGG(idx.name, ', ') AS DuplicateIndexes
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
WHERE ic.is_included_column = 0
GROUP BY tbl.name, col.name
HAVING COUNT(*) > 1;
```
**Result**: Two indexes on same column → **remove one!**

### Statistics: The Hidden Optimizer

> **Statistics** = data distribution info used by Query Optimizer.

```sql
-- View statistics
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatName,
    sp.last_updated,
    sp.rows,
    sp.modification_counter
FROM sys.stats s
JOIN sys.tables t ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
ORDER BY sp.modification_counter DESC;
```

**Update Stats**:
```sql
-- Specific
UPDATE STATISTICS Sales.DBCustomers;

-- All in DB
EXEC sp_updatestats;
```

**When to update?**
- After large data load
- When queries slow down
- `modification_counter` > 20% of rows

### Fragmentation & Maintenance

##### Check Fragmentation

```sql
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') s
JOIN sys.tables tbl ON s.object_id = tbl.object_id
JOIN sys.indexes idx ON s.object_id = idx.object_id AND s.index_id = idx.index_id
WHERE s.avg_fragmentation_in_percent > 10
ORDER BY s.avg_fragmentation_in_percent DESC;
```

| Fragmentation | Action |
|---------------|--------|
| < 10%         | Do nothing |
| 10% – 30%     | `REORGANIZE` |
| > 30%         | `REBUILD` |

##### Fix Fragmentation

```sql
-- Low fragmentation
ALTER INDEX idx_customers_country ON Sales.Customers REORGANIZE;

-- High fragmentation
ALTER INDEX idx_customers_country ON Sales.Customers REBUILD;
```

#### Real-World Query Example

```sql
SELECT
    fs.SalesOrderNumber,
    dp.EnglishProductName,
    dp.Color
FROM FactInternetSales fs
INNER JOIN DimProduct dp ON fs.ProductKey = dp.ProductKey
WHERE dp.Color = 'Black'
  AND fs.OrderDateKey BETWEEN 20101229 AND 20101231;
```

**Without index** → Full scan  
**With index on `Color`, `OrderDateKey`** → **Index seek** → 100x faster!

#### Best Practices & Pro Tips

| **Do** | **Don't** |
|------|---------|
| Index **WHERE**, **JOIN**, **ORDER BY** columns | Index every column |
| Use **filtered indexes** for sparse data | Ignore `sys.dm_db_index_usage_stats` |
| Update stats after bulk load | Rebuild indexes daily |
| Drop **unused indexes** | Create duplicate indexes |
| Use `INCLUDE` for covering | Forget `SET STATISTICS IO ON` |

```sql
-- Covering index (no key lookup!)
CREATE NONCLUSTERED INDEX idx_Covering_Color
ON DimProduct (Color)
INCLUDE (EnglishProductName);
```

### Scalability: Table Partitioning

#### What is Table Partitioning?

> **Table Partitioning** is the process of **splitting a large table into smaller, more manageable pieces** called **partitions**, while still allowing the table to be queried as a single logical unit.
> Think of it like **dividing a huge filing cabinet into labeled drawers** — easier to manage, faster to search.

#### Why Use Partitioning?

| Problem | Solved by Partitioning |
|-------|-----------------------|
| Large tables (> millions of rows) | Faster queries |
| Historical data | Archive old data |
| Maintenance (backup, index rebuild) | Do it per partition |
| Performance degradation | Isolate hot/cold data |

#### Advantages & Disadvantages

| **Advantages** | **Disadvantages** |
|----------------|-------------------|
| Faster **queries** on partitions | Complex setup |
| **Parallel operations** | Requires **Enterprise Edition** |
| **Sliding window** archiving | Not all queries benefit |
| Better **manageability** | Extra storage planning |

> **Note**: Full partitioning features require **SQL Server Enterprise** or **Developer Edition**.

#### Partitioning Concepts

| Component | Purpose |
|---------|--------|
| **Partition Function** | Defines **boundaries** (e.g., by year) |
| **Partition Scheme** | Maps boundaries to **filegroups** |
| **Filegroups** | Physical storage containers |
| **Files (.ndf)** | Actual data files on disk |

### Partition Function

```sql
CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31');
```

**Explanation**:
- `RANGE LEFT`: Values **<= boundary** go into that partition.
- Boundaries: `2023`, `2024`, `2025` → creates **4 partitions**:
  1. `<= 2023-12-31`
  2. `2024-01-01 to 2024-12-31`
  3. `2025-01-01 to 2025-12-31`
  4. `> 2025-12-31`

### Filegroups & Files

```sql
-- Create filegroups
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- Add physical files
ALTER DATABASE SalesDB ADD FILE
(NAME = 'P_2023', FILENAME = 'C:\...\P_2023.ndf') TO FILEGROUP FG_2023;
-- Repeat for others...
```

**Query Filegroups**:
```sql
SELECT 
    fg.name AS FileGroup,
    mf.name AS LogicalFile,
    mf.physical_name,
    mf.size / 128.0 AS SizeMB
FROM sys.filegroups fg
JOIN sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE mf.database_id = DB_ID('SalesDB');
```
### Partition Scheme

```sql
CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026);
```

**Maps**:
- Partition 1 → `FG_2023`
- Partition 2 → `FG_2024`
- etc.

### Create Partitioned Table

```sql
CREATE TABLE Sales.Order_partioned (
    OrderId INT,
    OrderDate DATE,
    Sales INT
) ON SchemePartitionByYear (OrderDate);
```
> The **partitioning column** (`OrderDate`) **must be part of the table**.

### Insert & Query Data

```sql
INSERT INTO Sales.Order_partioned VALUES 
(1, '2023-05-15', 100),
(2, '2024-05-15', 200),
(3, '2026-01-01', 300);
```

```sql
SELECT * FROM Sales.Order_partioned;
```

### Verify Partitioning
```sql
SELECT 
    p.partition_number AS Partition,
    f.name AS FileGroup,
    p.rows AS RowCount
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Order_partioned'
ORDER BY p.partition_number;
```

**Sample Output**:
| Partition | FileGroup | RowCount |
|---------|----------|--------|
| 1       | FG_2023  | 1      |
| 2       | FG_2024  | 1      |
| 4       | FG_2026  | 1      |


### Partition Maintenance

#### Switch Out (Archive)
```sql
-- Create staging table
CREATE TABLE Sales.Orders_2023_Archive (
    OrderId INT, OrderDate DATE, Sales INT
) ON FG_Archive;

-- Switch partition 1 to archive
ALTER TABLE Sales.Order_partioned 
SWITCH PARTITION 1 TO Sales.Orders_2023_Archive;
```

#### Merge / Split
```sql
-- Add new boundary
ALTER PARTITION FUNCTION PartitionByYear() 
MERGE RANGE ('2023-12-31');

-- Split for new year
ALTER PARTITION FUNCTION PartitionByYear() 
SPLIT RANGE ('2026-12-31');
```

#### Best Practices & Tips

| **Do** | **Don't** |
|------|---------|
| Partition on **date** or **natural key** | Partition on random columns |
| Use **sliding window** pattern | Forget filegroup planning |
| Align **indexes** with partition | Use in small tables |
| Test **partition elimination** | Assume all queries benefit |

```sql
-- Check if partition elimination works
SET STATISTICS IO ON;
SELECT * FROM Sales.Order_partioned 
WHERE OrderDate BETWEEN '2024-01-01' AND '2024-12-31';
-- Should scan only FG_2024
```
<img width="678" height="427" alt="image" src="https://github.com/user-attachments/assets/1d02a5c2-043e-4a7a-b94c-7a5c0babfcfc" />

## Advanced Queries: Subqueries & Metadata

#### What is Metadata?
> **Metadata** = **Data about data**  
> Information about tables, columns, indexes, constraints, etc.

```sql
-- List all tables
SELECT DISTINCT TABLE_NAME 
FROM INFORMATION_SCHEMA.COLUMNS;
```

**`INFORMATION_SCHEMA`** = ANSI-standard views for metadata.

#### Subqueries: Query Inside Query
> A **subquery** is a `SELECT` statement **nested inside** another query.

#### Types of Subqueries

| Type | Returns | Use Case |
|------|--------|--------|
| **Scalar** | 1 row, 1 column | `WHERE`, `SELECT` |
| **Row** | 1 row, multiple columns | Rare |
| **Table (Derived)** | Multiple rows | `FROM`, `JOIN` |

### Subquery Locations

#### SELECT Clause

```sql
SELECT
    ProductID,
    Product,
    Price,
    (SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products;
```

**Explanation**:
- Scalar subquery → returns **one value**.
- Same for **all rows**.

#### FROM Clause (Derived Table)

```sql
-- Rank customers by total sales
SELECT *,
       RANK() OVER(ORDER BY TotalSales DESC) AS SalesRank
FROM (
    SELECT CustomerID, SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) t;
```

**Explanation**:
- Inner query → **derived table** `t`
- Outer query → uses it like a real table

#### WHERE Clause

```sql
-- Products > average price
SELECT *
FROM Sales.Products
WHERE Price > (
    SELECT AVG(Price) FROM Sales.Products
);
```

**Explanation**:
- Scalar subquery in `WHERE`
- **Non-correlated** (runs once)

#### JOIN Clause

```sql
SELECT 
    c.*,
    ISNULL(o.TotalOrders, 0) AS TotalOrders
FROM Sales.Customers c
LEFT JOIN (
    SELECT CustomerID, COUNT(*) AS TotalOrders
    FROM Sales.Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID;
```

**Explanation**:
- Subquery in `JOIN` → acts like a **virtual view**

### Correlated vs Non-Correlated

| Type | Definition | Performance |
|------|-----------|-----------|
| **Non-Correlated** | Runs **once** | Faster |
| **Correlated** | Runs **per outer row** | Slower |

```sql
-- Correlated: Uses outer table reference
SELECT *,
       (SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS OrderCount
FROM Sales.Customers c;
```

### Operators: IN, EXISTS, ANY, ALL

#### IN

```sql
-- Orders by German customers
SELECT * FROM Sales.Orders
WHERE CustomerID IN (
    SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany'
);
```

#### EXISTS (Recommended for performance)

```sql
SELECT * FROM Sales.Orders o
WHERE EXISTS (
    SELECT 1 FROM Sales.Customers c
    WHERE c.Country = 'Germany' AND o.CustomerID = c.CustomerID
);
```

**Why `EXISTS` is better**:
- Stops at **first match**
- Works with `NULL`s safely

#### ANY & ALL

```sql
-- Female employees earning > ANY male
SELECT EmployeeID, FirstName, Salary
FROM Sales.Employees
WHERE Gender = 'F'
  AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');
```

```sql
-- > ALL = greater than the highest male salary
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')
```

### Practical Examples

#### 1. Products with Price > Average

```sql
SELECT * FROM (
    SELECT ProductID, Price, AVG(Price) OVER() AS AvgPrice
    FROM Sales.Products
) t
WHERE Price > AvgPrice;
```
> Uses **window function** — often better than subquery.

#### 2. Customer Order Count (Correlated)

```sql
SELECT 
    c.*,
    (SELECT COUNT(1) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS TotalOrders
FROM Sales.Customers c;
```

#### 3. Top Customer per Country

```sql
SELECT * FROM (
    SELECT 
        c.CustomerID, c.Country, SUM(o.Sales) AS TotalSales,
        ROW_NUMBER() OVER(PARTITION BY c.Country ORDER BY SUM(o.Sales) DESC) AS rn
    FROM Sales.Customers c
    JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.Country
) t
WHERE rn = 1;
```

### Best Practices & Performance

| **Do** | **Don't** |
|------|---------|
| Prefer `EXISTS` over `IN` | Use correlated in large tables |
| Use `JOIN` instead of subquery when possible | Nest too deeply |
| Use CTEs for readability | Forget aliases |
| Test with `SET STATISTICS IO ON` | Assume subquery = slow |

```sql
-- Better: Use JOIN
SELECT c.*, COUNT(o.OrderID)
FROM Sales.Customers c
LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, ...
```

# SQL Performance Mastery: 30 Golden Tips to Supercharge Your Queries

> **"Premature optimization is the root of all evil."** — Donald Knuth  
> **BUT** — *Smart, intentional optimization is the hallmark of a professional.*

## Table of Contents

| # | Tip | Category |
|---|-----|--------|
| 1 | Select Only What You Need | Query Design |
| 2 | Avoid Unnecessary `DISTINCT` & `ORDER BY` | Query Design |
| 3 | Limit Rows for Exploration | Debugging |
| 4 | Index Frequently Filtered Columns | Indexing |
| 5 | Avoid Functions on Columns | Sargability |
| 6 | Avoid Leading Wildcards | Sargability |
| 7 | Use `IN` Instead of `OR` | Query Logic |
| 8 | Prefer `INNER JOIN` | Join Performance |
| 9 | Use Explicit `JOIN` Syntax | Readability |
| 10| Index `ON` Clause Columns | Join Performance |
| 11| Filter Before Joining | Join Optimization |
| 12| Aggregate Before Joining | Aggregation |
| 13| Use `UNION` Instead of `OR` in Joins | Join Logic |
| 14| Use Join Hints When Needed | Advanced |
| 15| Use `UNION ALL` (Not `UNION`) | Set Operations |
| 16| `UNION ALL` + `DISTINCT` > `UNION` | Set Operations |
| 17| Use Columnstore for Aggregations | Indexing |
| 18| Pre-Aggregate for Reporting | Materialization |
| 19| Prefer `EXISTS` Over `IN` | Subqueries |
| 20| Avoid Redundant Logic | Query Logic |
| 21| Use Proper Data Types | Schema Design |
| 22| Use `NOT NULL` Where Possible | Schema Design |
| 23| Every Table Needs a Clustered PK | Schema Design |
| 24| Index Foreign Keys | Indexing |
| 25| Avoid Over-Indexing | Indexing |
| 26| Drop Unused Indexes | Maintenance |
| 27| Update Statistics Regularly | Maintenance |
| 28| Rebuild/Reorganize Indexes | Maintenance |
| 29| Partition Large Fact Tables | Scalability |
| 30| Combine Partitioning + Columnstore | Ultimate Performance |

## 30 Performance Tips (With Code!)

### 1. **Select Only What You Need**

```sql
-- Bad: Select everything
SELECT * FROM Sales.Orders

-- Good: Select only needed columns
SELECT OrderID, Sales, OrderDate FROM Sales.Orders
```
> **Why?** Reduces I/O, memory, and network usage.

### 2. **Avoid Unnecessary `DISTINCT` & `ORDER BY`**

```sql
-- Bad
SELECT DISTINCT CustomerID FROM Sales.Orders ORDER BY OrderDate

-- Good (if order doesn't matter)
SELECT CustomerID FROM Sales.Orders
```
> **Tip**: Only use `DISTINCT` when duplicates are possible and unwanted.

### 3. **Limit Rows for Exploration**

```sql
-- Bad
SELECT OrderID, Sales FROM Sales.Orders

-- Good
SELECT TOP 10 OrderID, Sales FROM Sales.Orders
```

> **Pro Tip**: Use `TOP 100` or `SET ROWCOUNT 100` during testing.

### 4. **Index Frequently Filtered Columns**

```sql
-- Query
SELECT * FROM Sales.Orders WHERE OrderStatus = 'Delivered'

-- Create Index
CREATE NONCLUSTERED INDEX IDX_Orders_OrderStatus 
ON Sales.Orders(OrderStatus)
```
> **Result**: Index seek instead of scan.

### 5. **Avoid Functions on Columns (Sargability!)**

```sql
-- Bad (non-sargable)
SELECT * FROM Sales.Orders WHERE YEAR(OrderDate) = 2025

-- Good (sargable)
SELECT * FROM Sales.Orders 
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31'

> **Sargable** = Search ARGument ABLE → uses index.

### 6. **Avoid Leading Wildcards**

```sql
-- Bad (full scan)
SELECT * FROM Sales.Customers WHERE LastName LIKE '%Gold%'

-- Good (index seek)
SELECT * FROM Sales.Customers WHERE LastName LIKE 'Gold%'
```

### 7. **Use `IN` Instead of Multiple `OR`**

```sql
-- Bad
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3

-- Good
WHERE CustomerID IN (1, 2, 3)
```

### 8. **Prefer `INNER JOIN`**

```sql
-- Fastest
INNER JOIN

-- Slower
LEFT/RIGHT JOIN

-- Slowest
FULL OUTER JOIN
```
> **Rule**: Use the least inclusive join that satisfies logic.

### 9. **Use Explicit `JOIN` Syntax**

```sql
-- Bad (old style)
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c, Sales.Orders o
WHERE c.CustomerID = o.CustomerID

-- Good
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
```

### 10. **Index `ON` Clause Columns**

```sql
-- Index both sides!
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID ON Sales.Orders(CustomerID)
CREATE NONCLUSTERED INDEX IX_Customers_CustomerID ON Sales.Customers(CustomerID)
```

### 11. **Filter Before Joining**

```sql
-- Best: Filter in subquery
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN (
    SELECT OrderID, CustomerID 
    FROM Sales.Orders 
    WHERE OrderStatus = 'Delivered'
) o ON c.CustomerID = o.CustomerID
```

### 12. **Aggregate Before Joining**

```sql
-- Best
SELECT c.FirstName, o.OrderCount
FROM Sales.Customers c
INNER JOIN (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM Sales.Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID
```
> **Avoid**: Correlated subqueries!

### 13. **Use `UNION` Instead of `OR` in Joins**

```sql
-- Bad
ON c.CustomerID = o.CustomerID OR c.CustomerID = o.SalesPersonID

-- Good
SELECT ... FROM ... JOIN ... ON c.CustomerID = o.CustomerID
UNION
SELECT ... FROM ... JOIN ... ON c.CustomerID = o.SalesPersonID
```

### 14. **Use Join Hints (When Needed)**

```sql
OPTION (HASH JOIN)  -- For large + small tables
OPTION (MERGE JOIN) -- For sorted data
OPTION (LOOP JOIN)  -- For small tables
```

### 15. **Use `UNION ALL` (Not `UNION`)**

```sql
-- Fast (allows duplicates)
SELECT CustomerID FROM Sales.Orders
UNION ALL
SELECT CustomerID FROM Sales.OrdersArchive
```

### 16. **`UNION ALL` + `DISTINCT` > `UNION`**

```sql
-- Need unique? Do this:
SELECT DISTINCT CustomerID FROM (
    SELECT CustomerID FROM Sales.Orders
    UNION ALL
    SELECT CustomerID FROM Sales.OrdersArchive
) t
```

### 17. **Columnstore for Aggregations**

```sql
CREATE CLUSTERED COLUMNSTORE INDEX IDX_Orders_CS ON Sales.Orders
```
> **100x faster** for `SUM`, `COUNT`, `GROUP BY` on large tables.

### 18. **Pre-Aggregate for Reporting**

```sql
SELECT YEAR(OrderDate), SUM(Sales)
INTO Sales.SalesSummary_Yearly
FROM Sales.Orders
GROUP BY YEAR(OrderDate)
```
### 19. **Prefer `EXISTS` Over `IN`**

```sql
-- Best for large tables
WHERE EXISTS (
    SELECT 1 FROM Sales.Customers c
    WHERE c.CustomerID = o.CustomerID AND c.Country = 'USA'
)
```
> Stops at **first match**, no duplication.

### 20. **Avoid Redundant Logic**

```sql
-- Good: Use window function
SELECT *,
    CASE 
        WHEN Salary > AVG(Salary) OVER() THEN 'Above Average'
        ELSE 'Below Average'
    END AS Status
FROM Sales.Employees
```

### 21–23. **Schema Design Tips**

```sql
CREATE TABLE CustomersInfo (
    CustomerID INT PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    BirthDate DATE,
    EmployeeID INT,
    CONSTRAINT FK_Employee FOREIGN KEY (EmployeeID) 
        REFERENCES Sales.Employees(EmployeeID)
)
```

> **Every table needs a clustered PK!**

### 24–30. **Indexing & Maintenance**

| Tip | Action |
|-----|--------|
| 24 | Index **foreign keys** |
| 25 | Avoid **over-indexing** |
| 26 | Drop **unused indexes** |
| 27 | `UPDATE STATISTICS` weekly |
| 28 | `REBUILD`/`REORGANIZE` indexes |
| 29 | **Partition** fact tables |
| 30 | **Columnstore + Partitioning** = |

## Golden Rule

> **Always check the execution plan!**

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
-- Run query
-- Check: Logical reads, CPU time, duration
```

> **No improvement in plan?** → **Prioritize readability.**

## Bonus: Query Performance Checklist

| Check | Done? |
|------|-------|
| Select only needed columns | [ ] |
| Avoid `*` in production | [ ] |
| Use `TOP` when testing | [ ] |
| Index `WHERE`/`JOIN` columns | [ ] |
| Avoid functions on columns | [ ] |
| Use `EXISTS` not `IN` | [ ] |
| Filter early | [ ] |
| Check execution plan | [ ] |


## Resources

- [SQL Server Execution Plans](https://www.red-gate.com/simple-talk/sql/performance/execution-plan-basics/)
- [Sargability Guide](https://www.sqlshack.com/sargable-queries/)
- [Columnstore Indexes](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-overview)


## Contribute

Found a new tip?  
→ Open a PR! Let's make SQL **fast and beautiful**.

**Made with passion for performance**  
*Your queries deserve to fly.*


## How to Use This Repo

- Clone the repo: `git clone https://github.com/yourusername/learning-mssql.git`.
- Navigate to topics and run SQL snippets in your SSMS or Azure Data Studio.
- Each code example is self-contained—copy-paste and execute!
- Feel free to star ⭐ or fork if you find it helpful.

## Contributing

Contributions are welcome! If you spot errors, have better explanations, or want to add topics:
- Fork the repo.
- Create a branch: `git checkout -b feature/new-topic`.
- Commit changes and open a Pull Request.
- Let's learn together! 🤝

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
