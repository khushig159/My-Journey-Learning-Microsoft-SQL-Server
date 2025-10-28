 SELECT
CustomerID,
Score,
COALESCE(Score,0) Score2,
AVG(Score) OVER () AVGScore,
AVG(COALESCE(Score,0)) OVER() AVGScore2
FROM Sales.Customers

--full name
--10 bonus to customer's score
SELECT 
CustomerID,
FirstName,
LastName,
ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') AS FullName,
Score,
ISNULL(Score,0)+10 as BonusScore
FROM Sales.Customers

--Sort the customers from lowest to highest scores
SELECT 
CustomerID,
Score,  
COALESCE(Score,999999999999999999999) AS Score2,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END
FROM Sales.Customers
ORDER BY COALESCE(Score,999999999999999999999)


--NULLIF-->Find the sales price for each order by dividing sales by quantity
SELECT
OrderID,
Sales,
Quantity,
Sales / NULLIF(Quantity,0) AS price
FROM Sales.Orders

--Customers who have scores
SELECT * FROM Sales.Customers WHERE Score IS NOT NULL

SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders

SELECT c.*, o.OrderID FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID=o.CustomerID
WHERE o.CustomerID IS NULL

