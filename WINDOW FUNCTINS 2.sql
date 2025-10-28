SELECT
OrderID, 
SUM(Sales) OVER() Total,
SUM(Sales) OVER(PARTITION BY ProductID) TotalEachProduct
FROM Sales.Orders

SELECT 
OrderID,
ProductID,
Sales,
SUM(Sales) OVER() Total,
ROUND(CAST(Sales AS FLOAT)/SUM(Sales) OVER() * 100,2) percentageOFtotal
FROM Sales.Orders

--------------------------------------------

SELECT 
OrderID,
ProductID,
Sales,
AVG(Sales) OVER() AVG,
AVG(Sales) OVER(PARTITION BY ProductID) AVgEachProduct
--ROUND(CAST(Sales AS FLOAT)/SUM(Sales) OVER() * 100,2) percentageOFtotal
FROM Sales.Orders

SELECT * FROM(
SELECT
CustomerID,
OrderID,
PRoductID,
Sales,
--COALESCE(Sales,0) Sale,
AVG(COALESCE(Sales,0)) OVER() AvgSales
FROM Sales.Orders
)t
WHERE Sales>AvgSales

-----------------------------------------

SELECT
OrderID,
ProductID,
MAX(COALESCE(Sales,0)) OVER(PARTITION BY ProductID) Highest,
MIN(COALESCE(Sales,0)) OVER(PARTITION BY ProductID) Lowest
FROM Sales.Orders

SELECT * FROM(
SELECT
EmployeeID,
Salary,
MAX(Salary) OVER() highestSalry
FROM Sales.Employees
)t
WHERE Salary=highestSalry



--Find the deviation of each sales from the minimum and maximum sales amounts
SELECT
OrderID,
ProductID,
Sales,
MAX(COALESCE(Sales,0)) OVER() Highest,
MIN(COALESCE(Sales,0)) OVER() Lowest,
Sales - MIN(Sales) OVER() Deviationmin,
MAX(Sales)  OVER() -Sales Deviationmax
FROM Sales.Orders

------------------------------------------------------------------
--calculate moving average of sales for each product over time

SELECT
OrderID,
ProductID,
OrderDate,
Sales,
AVG(Sales) OVER(PARTITION BY ProductID) AvgProduct,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvgProduct
FROM Sales.Orders

------------------------------------------------------------------
--calculate moving average of sales for each product over time inclusing only the next order

SELECT
OrderID,
ProductID,
OrderDate,
Sales,
AVG(Sales) OVER(PARTITION BY ProductID) AvgProduct,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvgProduct,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate
ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
) MovingAvgProductincnext

FROM Sales.Orders