USE SalesDB

SELECT 
OrderID,
OrderDate,
ShipDate,
CreationTime,
DATETRUNC(day,CreationTime) AS Day_dp,
DATETRUNC(minute,CreationTime) AS Minute_dp,
DATEPART(year,CreationTime) AS year_dp,
DATEPART(day,CreationTime) AS day_dp,
DATENAME(weekday,CreationTime) AS day_name,
DATENAME(month,CreationTime) AS month_name,
DATEPART(month,CreationTime) AS month_dp,
DATEPART(hour,CreationTime) AS hour_dp,
DATEPART(quarter,CreationTime) AS quarter_dp,
DATEPART(week,CreationTime) AS week_dp,
YEAR(CreationTime) Year,
MONTH(CreationTime) Month,
DAY(CreationTime) Day,
EOMONTH(CreationTime) EndOfMonth,
--'2025-08-20' HardCoded,
GETDATE() 
FROM Sales.Orders

SELECT
DATETRUNC(month,CreationTime) Creation,
COUNT(*),
CAST(DATETRUNC(month,CreationTime) AS DATE) StartOfMonth
FROM Sales.Orders
GROUP BY DATETRUNC(month,CreationTime)


--How many orders were placed each year?
SELECT 
YEAR(OrderDate),
COUNT(*) NoOFOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate)

--How many orders were placed each month?
SELECT 
DATENAME(month,OrderDate)AS OrderMonth,
COUNT(*) NoOFOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)

SELECT * FROM Sales.Orders
WHERE MONTH(OrderDate)=2


SELECT 
OrderID,
CreationTime,
FORMAT(CreationTime,'MM- dd-yyyy') as USA_FORMAT,
FORMAT(CreationTime,'dd') as dd,
FORMAT(CreationTime,'ddd') as ddd,
'Day'+' ' + FORMAT(CreationTime,'ddd MMM') + ' '+
'Q' + DATENAME(quarter,CreationTime) + ' ' + FORMAT(CreationTime,'yyyy') + ' ' + FORMAT(CreationTime, 'hh:mm:ss tt' ) AS Custom,
FORMAT(CreationTime,'dddd') as dddd,
FORMAT(CreationTime,'MM') as MM
FROM Sales.Orders

--CONVERT
SELECT
CONVERT (INT,'123') AS [String to Int CONVERT],
CONVERT(DATE,'2025-04-22') AS [String to Date],
CONVERT(DATE,CreationTime) AS [DateTime to Date]
FROM Sales.Orders

SELECT
OrderID,
OrderDate,
ShipDate,
DATEADD(month,3,OrderDate) AS ThreeMonthsLater,
DATEADD(year,2,OrderDate) AS TwoYearsLater,
DATEDIFF(day,Orderdate,ShipDate) AS DateDiff
FROM Sales.Orders

--Age of Employees
 SELECT 
 EmployeeID,
 BirthDate,
 DATEDIFF(year,BirthDate,GETDATE()) AS DOB
 FROM Sales.Employees

 --Find the average shipping duration in days for each month
 SELECT
 --OrderDate,
 --ShipDate,
 MONTH(OrderDate) AS OrderDate,
 AVG(DATEDIFF(day,OrderDate,ShipDate)) AVGShip
 FROM Sales.Orders
 GROUP BY MONTH(OrderDate)

 --Find the Number of days between each order and previous order
 SELECT
 OrderID,
 OrderDate CurrentOrderDate,
 LAG(OrderDate) OVER (ORDER BY OrderDate) AS PreviousOrder,
 DATEDIFF(day,LAG(Orderdate) OVER (ORDER BY OrderDate),OrderDate) AS  DayDiff
 FROM Sales.Orders

 --ISDATE
 SELECT
 OrderDate,
 ISDATE(OrderDate),
 CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
 ELSE '9999-09-09'
 END NewOrderDate
 FROM
 (
 SELECT '2025-08-20' AS Orderdate UNION
  SELECT '2025-08-21'  UNION
 SELECT '2025-08-23' UNION
  SELECT '2025-08' 
 )t
 --WHERE ISDATE(OrderDate)=0