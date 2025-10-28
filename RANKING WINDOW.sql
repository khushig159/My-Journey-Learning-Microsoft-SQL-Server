SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) rank1,
RANK() OVER(ORDER BY Sales DESC) rank,
DENSE_RANK() OVER(ORDER BY Sales DESC) rank2

FROM Sales.Orders

--Find the top highest sales for each product
SELECT * FROM(
SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) rank1
FROM Sales.Orders
)t
WHERE rank1=1

--Find the lowest 2 customera based on their total sales
SELECT * FROM(
SELECT
CustomerID,
SUM(Sales) TotalSales,
ROW_NUMBER() OVER(ORDER BY SUM( Sales)) RankCustomers
FROM Sales.Orders
GROUP BY 
CustomerID
)t
WHERE RankCustomers<=2

--Assign unique IDs to the rows of the 'Orders Archive'
SELECT
*,
ROW_NUMBER() OVER(ORDER BY OrderID,OrderDate) UniqueID 
FROM Sales.OrdersArchive 

--identify duplicate rows in the table ordersArchive
--and return a clean result without any duplicates

SELECT * FROM (
SELECT  
ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime Desc) rn,
* FROM Sales.OrdersArchive
)t
WHERE rn=1

 -------NTILE()
 SELECT 
 OrderID,Sales,
 NTILE(1) OVER(ORDER BY Sales DESC) OneBuc,
 NTILE(2) OVER(ORDER BY Sales DESC) TwoBuc,
 NTILE(3) OVER(ORDER BY Sales DESC) ThreeBuc,
 NTILE(4) OVER(ORDER BY Sales DESC) FourBuc
 FROM Sales.Orders

 --for datasegmentation and equal load processing

 --segment alll orders into 3 categories, high,medium and low
 SELECT *,
 CASE WHEN Buckets=1 THEN 'HIGH'
 WHEN Buckets=2 THEN 'MEDIUM'
 WHEN Buckets=3 THEN 'LOW'
 END
 FROM(
  SELECT
  OrderID,
  Sales,
  NTILE(3) OVER(ORDER BY Sales DESC) Buckets
  FROM Sales.Orders
  )t

 ---Inorder  to export data, divide the orders into 2 grps

SELECT 
NTILE(4) OVER(ORDER BY OrderID) Buckets,
*
FROM Sales.Orders


----------------------------------------------------------------------------
--find the products that fall within the highest 40% of prices
SELECT * FROM(
SELECT
Product,
Price,
CUME_DIST() OVER(ORDER BY Price DESC) DistRank
FROM Sales.Products
)t
WHERE DistRank<=0.4