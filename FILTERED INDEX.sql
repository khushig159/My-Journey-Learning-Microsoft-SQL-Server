SELECT * FROM Sales.Customers
WHERE Country='USA'

CREATE NONCLUSTERED INDEX idx_customers_country
ON Sales.Customers (Country)
WHERE Country ='USA'