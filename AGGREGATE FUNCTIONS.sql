---total no of orders
SELECT
COUNT(*) AS total_orders
FROM orders

--total sales of all orders
SELECT
COUNT(*) AS total_orders,
SUM(sales) AS total_sales,
AVG(sales) AS Average_sales,
MAX(sales) AS highest_sales,
MIN(sales) AS lowest_sales
FROM orders

