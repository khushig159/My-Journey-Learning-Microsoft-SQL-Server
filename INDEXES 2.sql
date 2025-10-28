--HEAP
SELECT * INTO FactInternetSales_HP FROM FactInternetSales

 --ROWSTORE
SELECT * INTO FactInternetSales_RS FROM FactInternetSales

CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
ON FactInternetSales_RS (SalesOrderNumber,SalesOrderLineNumber) 

--ColumnStore
SELECT * INTO FactInternetSales_CS FROM FactInternetSales

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
ON FactInternetSales_CS  

