# Learning Microsoft SQL Server (MSSQL) 📚

This repository documents my journey learning Microsoft SQL Server, from installation to advanced queries and database management. It's designed for beginners and includes code examples with explanations. Whether you're just starting out or looking to refresh your skills, feel free to follow along! 

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites and Setup](#prerequisites-and-setup)
- [Topics](#topics)
  - [Basics](#basics)
    - [Creating Your First Database](#creating-your-first-database)
- [How to Use This Repo](#how-to-use-this-repo)
- [Contributing](#contributing)
- [License](#license)

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
