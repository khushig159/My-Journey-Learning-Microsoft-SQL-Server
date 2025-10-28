USE SalesDB

SELECT * FROM Sales.Products
 
CREATE UNIQUE NONCLUSTERED INDEX idx_Products_category
ON Sales.Products (Product)

INSERT INTO Sales.Products (ProductID,Product) VALUES(106,'Caps')
--error