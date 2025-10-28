 SELECT
* ,
(SELECT COUNT(1) FROM Sales.Orders o WHERE o.CustomerID=c.CustomerID ) TotalSales
FROM Sales.Customers c

--EXISTS OPERATOR
--show details of orders made by customer in germany
SELECT * FROM Sales.Orders o
WHERE  EXISTS(
SELECT * FROM Sales.Customers c
WHERE Country='Germany'
AND o.CustomerID=c.CustomerID)