SELECT
Category,
SUM(Sales) AS TotalSales
FROM(
SELECT
OrderID,
Sales,
CASE
	WHEN Sales > 50 THEN 'High'
	WHEN Sales > 20 THEN 'Medium'
	ELSE 'Low'
END Category
FROM Sales.Orders
)t
GROUP BY Category

SELECT 
OrderID, Sales,
CASE	
	WHEN Sales > 50 THEN 'High'
	WHEN Sales > 20 THEN 'Medium'
	ELSE 'Low'
END Category
FROM Sales.Orders

--MAPPING
SELECT
EmployeeID,
FirstName,
LastName,
Gender,
CASE
	WHEN Gender='F' THEN'Female'
	WHEN Gender='M' THEN 'Male'
	ELSE 'NOT AVAILABLE'
END GenderFullText
FROM Sales.Employees

SELECT
CustomerID,
FirstName,
LastName,
Country ,
CASE
 WHEN Country ='Germany' THEN 'DE'
 WHEN Country ='USA' THEN 'US'
 ELSE 'N/A'
 END CountryAbbreviation 
FROM Sales.Customers

SELECT DISTINCT Country
FROM Sales.Customers

--average scores of customers and treat NULL as0
--provide details such as customerid and lastname

SELECT
CustomerID,
LastName,
Score,
AVG(ISNULL(Score,0)) OVER() AvgCustomer
FROM Sales.Customers

--Count how manu times each customer made an order with sales greater than 30
SELECT
--OrderID,
CustomerID,
--Sales,
SUM(CASE
	WHEN Sales>30 THEN 1 ELSE 0
	END) TotalOrdersHIGH,
	COUNT(*) TotalOrders
--CASE
--WHEN Sales>30 THEN 1 ELSE 0
--END SalesFlag
 FROM Sales.Orders
GROUP BY CustomerID

