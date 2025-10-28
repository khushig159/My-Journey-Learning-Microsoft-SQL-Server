--find running total of sales for each month
SELECT * FROM Sales.Monthly_summaryy

SELECT OrderMonth, TotalSales, SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM Sales.Monthly_summaryy

--Provide views that combines details from orders,products,customers and employees

SELECT * FROM Sales.OrderDetails

--provide a view for EU Sales Team
--that combines details from All tables
--and excludes data related to the usa
