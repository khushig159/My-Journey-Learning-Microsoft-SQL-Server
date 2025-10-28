--TIP 1-->SALECT ONLY WHAT YOU NEED

--TIP2-->AVOID UNNECESSARY DISTINCT & ORDER BY

--TIP3-->FOR EXPLORATION PURPOSE,LIMIT ROWS
SELECT OrderId,sales FROM Sales.Orders--wrong
SELECT TOP 10 OrderID,Sales FROM Sales.Orders--right

--TIP4-->CREATE NONCLUSTERED INDEX ON FREQUENCTY USED COLUMNS IN WHERE CLAUSE

--TIP5-->AVOID APPLYTING FUNCTIONS TO COLUMNS IN WHERE CLAUSE

SELECT * FROM Sales.Orders
WHERE LOWER(OrderStatus) ='deliverd'---bad

-- Tip 6: Avoid leading wildcards as they prevent index usage

-- Bad Practice
SELECT *
FROM Sales.Customers
WHERE LastName LIKE '%Gold%'

-- Good Practice
SELECT *
FROM Sales.Customers
WHERE LastName LIKE 'Gold%'

-- Tip 7: Use IN instead of Multiple OR

-- Bad Practice
SELECT *
FROM Sales.Orders
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3

-- Good Practice
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (1, 2, 3)

-- Tip 7: Avoid applying functions to columns in WHERE clauses

-- Bad Practice
SELECT *
FROM Sales.Orders
WHERE YEAR(OrderDate) = 2025

-- Good Practice
SELECT *
FROM Sales.Orders
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31'

--PERFORMANCE TIPS IN JOINS

-- Tip 8: Understand The Speed of Joins & Use INNER JOIN when possible

-- Best Performance
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- Slightly Lower Performance
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
RIGHT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- Worst Performance
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
OUTER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

