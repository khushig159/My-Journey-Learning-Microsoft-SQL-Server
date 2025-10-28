--DROP VIEW Sales.Monthly_summaryy

IF OBJECT_ID ('Sales.Monthly_summaryy','V') IS NOT NULL
DROP VIEW Sales.Monthly_summaryy;
GO

CREATE  VIEW  Sales.Monthly_summaryy AS(
SELECT
DATETRUNC(month,OrderDate) OrderMonth,
SUM(Sales) TotalSales,
COUNT(OrderID) TotalOrders,
SUM(Quantity) TotalQuantities
FROM Sales.Orders
GROUP BY DATETRUNC(month,OrderDate) 
)


