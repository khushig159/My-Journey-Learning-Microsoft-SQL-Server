SELECT FirstName,LastName FROM Sales.Customers
UNION ALL
SELECT FirstName,LastName FROM Sales.Employees

--EXCEPT->returns all distinct rows from the first query that are not found in the second query
SELECT FirstName,LastName FROM Sales.Employees
EXCEPT
SELECT FirstName,LastName FROM Sales.Customers

SELECT FirstName,LastName FROM Sales.Employees
INTERSECT
SELECT FirstName,LastName FROM Sales.Customers

SELECT 
'Orders' AS SourceTable,
 [OrderID],
[ProductID]
 ,[CustomerID]
  ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
'OrdersArchive' AS SourceTable,
 [OrderID],
[ProductID]
 ,[CustomerID]
  ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID