--STUCTURE-->CLUSTERED ND NON-CLUSTERED 

--SELECT
--* 
--INTO Sales.DBCustomers
--FROM Sales.Customers

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

CREATE CLUSTERED INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName)

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName)

SELECT * FROM Sales.DBCustomers WHERE Country='USA' AND Score>50

--DROP INDEX idx_DBCustomers_CuntryScore ON Sales.DBCustomers

CREATE INDEX idx_DBCustomers_CuntryScore
ON Sales.DBCustomers (Country,Score)

SELECT * FROM Sales.DBCustomers
WHERE LastName='Brown'