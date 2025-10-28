CREATE VIEW Sales.OrderDetails AS(
SELECT
o.OrderID,
o.OrderDate,
o.Sales,
p.Product,
p.Category,
COALESCE(c.FirstName,'')+ ' ' + COALESCE(c.LastName,'') AS CustomerName,
COALESCE(e.FirstName,'')+ ' ' + COALESCE(e.LastName,'') AS EmployeerName,
  c.Country CustomerCountry,
o.Quantity
FROM Sales.Orders o
LEFT JOIN Sales.Products p
ON p.ProductID=o.ProductID
LEFT JOIN Sales.Customers c
ON c.CustomerID=o.CustomerID
LEFT JOIN Sales.Employees e
ON e.EmployeeID=o.SalesPersonID
WHERE c.Country!='USA'
)