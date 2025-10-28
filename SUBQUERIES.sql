 USE SalesDB

SELECT * FROM Sales.Orders

--Metadata -->data about data

SELECT
DISTINCT TABLE_NAME FROM
INFORMATION_SCHEMA.COLUMNS

--SUBQUER--> query inside main query
--non correlated and correlated

--find the products that have price higher than the average price of all products

SELECT * FROM(
SELECT 
ProductID,
Price,
AVG(Price) OVER() AvgPrice
FROM Sales.Products
)t
WHERE price>AvgPrice

--rank customers based on total amount of sales
SELECT 
*,
RANK() OVER(ORDER BY Toalsales DESC) rankofsales
FROM(
SELECT 
CustomerID,
SUM(Sales) Toalsales
FROM Sales.Orders
GROUP BY CustomerID
)t

  ---show the products ids,product names prices and total numbe rof orders
  SELECT
  ProductID,
  Product,
  Price,
  (
  SELECT 
  COUNT(*) 
  FROM Sales.Orders
  ) AS TotalOrders
  FROM Sales.Products

--show all customer details and find the total orders of each customer
--SUBQUERY USING JOINS
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders

SELECT 
CustomerID,
COUNT(OrderID) AS TotalOrders
FROM(
 SELECT c.CustomerID, o.OrderID
FROM Sales.Customers as c
LEFT JOIN Sales.Orders as o
ON c.CustomerID=o.CustomerID
)t
GROUP BY CustomerID

SELECT 
CustomerID,
COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID

SELECT
c.*,
o.TotalOrders
FROM Sales.Customers c
LEFT JOIN(
SELECT 
CustomerID,
COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID) o
ON c.CustomerID=o.CustomerID

--SUBQUERY IN WHERE CLAUSE
--find product that have price higher than the avergae price of all products
SELECT *
FROM Sales.Products
WHERE Price > (
SELECT AVG(Price) FROM Sales.Products
)

--IN QUERy
--show detail of orders made by customers in germnay
SELECT * FROM Sales.Orders
WHERE CustomerID IN (
SELECT CustomerID FROM Sales.Customers WHERE Country='Germany')

--find female employee whose salaries are greater
--than the salaries of any male employess
SELECT 
EmployeeID, FirstName, Gender,Salary
FROM Sales.Employees
WHERE GENDER ='F'
AND Salary > ANY (
SELECT 
Salary
FROM Sales.Employees
WHERE GENDER ='M'
)

--greater tha all then we use ALL
--because > use scales that is only one value, but here w e get multiple

