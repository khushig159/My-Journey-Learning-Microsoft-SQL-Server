--WINDOW FUNCTION(Analytic functions)
--find total sales across all orders
SELECT 
OrderId,
OrderDate,
ProductID,
SUM(Sales) TotalSales
FROM .Sales.Orders
GROUP BY ProductID,OrderId,OrderDate

SELECT
ProductID,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSales
FROM Sales.Orders


--WINDOW SYNTAXES

 SELECT 
 OrderID,
 OrderDate,
 Sales,
 SUM(Sales) OVER() TotalSales,
 SUM(Sales) OVER(PARTITION BY ProductID)
 FROM Sales.Orders

 --Find the total sales for each combination of product and order status
 SELECT
 ProductID,
 OrderStatus,
 OrderID,
 Sales,
 SUM(Sales) OVER() TotalSales,
 SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts,
 SUM(Sales) OVER(PARTITION BY ProductID,OrderStatus) TotalSalesByProductsandStatus
 FROM Sales.Orders

--rank each other based on their sales from highest to lowest
SELECT
OrderID,
OrderDate,
Sales,
RANK() OVER(ORDER BY Sales DESC) RankSales
FROM Sales.Orders


SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TOTALSALES
FROM Sales.Orders

SELECT
OrderID,
OrderDate,
COUNT(*) OVER()  TotalOrders,
COUNT(*) OVER(PARTITION BY CustomerID) OrdersByCustomers
FROM Sales.Orders

 SELECT
 COUNT(Score) OVER() TotalSCores,
  COUNT(1) OVER() Total
 FROM Sales.Customers

SELECT
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) checking
FROM Sales.Orders

---------------------------------------------------------------
SELECT * FROM(
SELECT 
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) checking
FROM Sales.OrdersArchive
)t
WHERE checking  > 1

