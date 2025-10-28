USE MyDatabase

SELECT *
FROM customers
WHERE first_name LIKE '__r%'

SELECT * FROM customers
SELECT * FROM orders

--INNER JOIN
SELECT * FROM customers
INNER JOIN orders
ON customer_id=id

SELECT
customers.id,
customers.first_name,
orders.order_id,
orders.sales
FROM customers
INNER JOIN orders
ON customers.id=orders.customer_id

SELECT
C.id,
C.first_name,
O.order_id,
O.sales
FROM customers AS C
INNER JOIN orders AS O
ON C.id=O.customer_id

--LEFT JOIN

SELECT * FROM customers
LEFT JOIN orders
ON customers.id=orders.customer_id

--RIGHT JOIN

SELECT * FROM customers
RIGHT JOIN orders
ON customers.id=orders.customer_id

--FULL JOIN

SELECT * FROM customers
FULL JOIN orders
ON customers.id=orders.customer_id

--Customers who haven't place any order(LEFT ANTI JOIN)
SELECT * FROM customers
LEFT JOIN orders
ON customers.id=orders.customer_id
WHERE orders.customer_id IS NULL 

--RIGHT ANTI JOIN
SELECT * FROM customers
RIGHT JOIN orders
ON customers.id=orders.customer_id
WHERE customers.id IS NULL

--FULL ANTI JOIN (returns only rows that don't match in either tables)
SELECT * FROM customers
FULL JOIN orders
ON customers.id=orders.customer_id
WHERE 
customers.id IS NULL OR
orders.customer_id IS  NULL

--ONLY MATCHING
--get all customers along with their orders, but only for customers who have placed an order(without using INNER JOIN)
SELECT * FROM customers AS c
LEFT JOIN orders AS o
ON c.id=o.customer_id
WHERE o.customer_id IS NOT NULL

--CROSS JOIN
SELECT * FROM customers AS c
CROSS JOIN orders AS o

