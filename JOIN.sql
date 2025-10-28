USE SalesDB

SELECT * FROM Sales.Customers
SELECT * FROM Sales.Employees
SELECT * FROM Sales.Orders
SELECT * FROM Sales.OrdersArchive
SELECT * FROM Sales.Products

SELECT 
o.OrderID, o.Sales, c.FirstName,c.LastName,p.Product AS ProductName ,p.Price,e.FirstName as EmployeeName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID=c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID=p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID
