SELECT
* 
--INTO #OrderTemp
FROM Sales.Orders

DELETE FROM #OrderTemp
WHERE OrderStatus = 'Delivered'

SELECT * FROM #OrderTemp

SELECT * 
INTO Sales.OrderTest
FROM #OrderTemp