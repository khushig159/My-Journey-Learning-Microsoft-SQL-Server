SELECT *
--INTO FactResellerSales_HP
FROM FactResellerSales

SELECT * FROM FactResellerSales_HP ORDER BY SalesOrderNumber

SELECT * FROM FactResellerSales ORDER BY SalesOrderNumber

SELECT * FROM FactResellerSales_HP ORDER BY SalesOrderNumber

SELECT * FROM FactResellerSales WHERE CarrierTrackingNumber='4911-403C-98'

SELECT * FROM FactResellerSales_HP WHERE CarrierTrackingNumber='4911-403C-98'

CREATE NONCLUSTERED INDEX idx_FactReseller_CTA ON FactResellerSales (CarrierTrackingNumber)

SELECT 
p.EnglishProductName AS ProductName,
SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales_HP s
JOIN DimProduct p
ON p.ProductKey=s.ProductKey
GROUP BY p.EnglishProductName

SELECT 
p.EnglishProductName AS ProductName,
SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales s
JOIN DimProduct p
ON p.ProductKey=s.ProductKey
GROUP BY p.EnglishProductName

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactResellerSalesHP ON FactResellerSales_HP
 
SELECT 
o.Sales,
c.Country
FROM Sales.Orders o
LEFT JOIN Sales.Customers c WITH (INDEX([PK_customers]))
ON o.CustomerID=c.CustomerID
--OPTION (HASH JOIN) 
