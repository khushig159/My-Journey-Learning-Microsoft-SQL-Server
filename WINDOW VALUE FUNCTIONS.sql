--LAG AND LEAD
--analyse the month over month performanve by finding the percentage chnage in sales between the current and previous month

SELECT *,
CurrentMonthSales-PrevMonth AS monthchnage,
ROUND(CAST((CurrentMonthSales-PrevMonth) AS FLOAT)/PrevMonth*100 ,2) AS monthchnageprecent

FROM(
SELECT
--OrderID,
--OrderDate,
--Sales,
MONTH(OrderDate) OrderMonth,
---FORMAT(OrderDate,'MMMM') AS  ORDERMONTH,
SUM(Sales) CurrentMonthSales,
LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PrevMonth 
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
)t

-----------------
--rank customers based on the avg days between their orders
SELECT  
CustomerID,
AVG(DATEDIFFer) AvgDays,
RANK() OVER(ORDER BY COALESCE(AVG(DATEDIFFer),99999)) Rankavg
--AVG(DATEDIFFer) OVER(PARTITION BY CustomerID) AS avgorder
--RANK() OVER(ORDER BY avgorder) AS RANKING
FROM(
SELECT
OrderID,
CustomerID,
OrderDate CurrentOrder,
LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ) Nextorder,
DATEDIFF(day,OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ) ) AS DATEDIFFer
FROM Sales.Orders
)t
GROUP BY CustomerID

-------------------------------------------------------
SELECT
OrderID,
ProductID,
Sales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2,
Sales-FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSalestoSalesDIFF,
MIN(Sales) OVER(PARTITION BY ProductID) LowestSales2
FROM Sales.Orders
