--CTE --> COMMON TABLE EXPRESSION
--Temporary, named result set, that can be used multiple times within your query to simplify and organize complex query.

---CTE-->Non-recursive & recuisive
--NonRecursive--> Standalone CTE and Nested CTE
--STANDALONE CTE-->Defined and used independently
-------------------Runs independentlyy as it is self contained and doesn't rey on other CTEs or queries


----STANDALONE CTE
--NESTED CTE
--a nested cte uses the result of another cte , so it can't run independently

--step1-find total sales per customer
WITH CTE_TotalSales AS
(
SELECT CustomerID, SUM(Sales) AS totalSales
FROM Sales.Orders
GROUP BY CustomerID
)
--step2: find the last order date for each customer
,CTE_LastOrder AS(
SELECT 
CustomerID,
MAX(OrderDate) AS LastOrder
FROM Sales.Orders
GROUP BY CustomerID
)
--step3 : rank customers based on total sales per customer
, CTE_customerRank AS (
SELECT 
CustomerId,
TotalSales,
RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM CTE_TotalSales
)
--STep4: segement customers based on their total sales
,CTE_customerSegment AS(
SELECT 
CustomerID,
CASE WHEN totalSales > 100 THEN 'High'
     WHEN totalSales > 50 THEN 'Medium'
     Else 'Low'
END CustomerSegment
FROM CTE_TotalSales
)
--Main query
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
ISNULL(cts.totalSales,0) TotalSales,
cts2.LastOrder LastOrder,
cts3.CustomerRank Customerrank,
cts4.CustomerSegment CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts
ON cts.CustomerID=c.CustomerID
LEFT JOIN CTE_LastOrder cts2
ON cts2.CustomerID=c.CustomerID
LEFT JOIN CTE_customerRank cts3
ON cts3.CustomerID=c.CustomerID
LEFT JOIN CTE_customerSegment cts4
ON cts4.CustomerID=c.CustomerID


