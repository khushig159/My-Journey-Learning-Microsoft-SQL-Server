--TABLES-->TEMPORARY AND PERMAMNENT
--PERMANENT--> Create/Select and CTAS
--Temporary tables stores intermediate  results in temporary storage withing the database during the session
--then the database will drop all temporary tables once the session ends

IF OBJECT_ID('Sales.MonthlyOrders','U') IS NOT NULL
DROP TABLE Sales.MonthlyOrders;
GO

SELECT 
DATENAME(month,Orderdate) Ordermonth,
COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month,Orderdate)

SELECT * FROM Sales.MonthlyOrders



