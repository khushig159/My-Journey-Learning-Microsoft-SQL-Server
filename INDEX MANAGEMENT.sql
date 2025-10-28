--LIST ALL INDEXES ON A SPECIFIC TABLE

sp_helpindex 'Sales.DBCustomers'

--montitor index usage
--sys-->contains metadata about database tables,views,indexes etc
SELECT 
tbl.name AS TableName,
--object_id,
idx.name AS IndexName,
idx.type_desc AS IndexType,
idx.is_primary_key AS primaryKey,
idx.is_unique AS IsUniue,
idx.is_disabled AS IsDisabled,
s.user_scans AS UserScans,
s.user_seeks AS UserSeeks,
s.user_updates AS UserUpdates,
s.user_lookups AS UserLookups,
COALESCE(s.last_user_seek,s.last_user_scan) LastUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id=tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id=idx.object_id
AND s.index_id=idx.index_id
ORDER BY tbl.name, idx.name

SELECT * FROM sys.tables

SELECT * FROM sys.dm_db_index_usage_stats

SELECT
fs.SalesOrderNumber,
dp.EnglishProductName,
dp.Color
FROM FactInternetSales fs
INNER JOIN DimProduct dp
ON fs.ProductKey=dp.ProductKey
WHERE dp.Color='Black'
AND fs.OrderDateKey BETWEEN 20101229 AND 20101231

--monitor missing indexes

SELECT * FROM sys.dm_db_missing_index_details

--monitor duplicate indexes
SELECT 
tbl.name AS tableName,
col.name AS IndexColumn,
STRING_AGG(idx.name, ', ') AS IndexNames,
STRING_AGG(idx.type_desc, ', ') AS IndexTypes,
COUNT(*) OVER(PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id=tbl.object_id
JOIN sys.index_columns ic ON idx.object_id=ic.object_id AND idx.index_id=ic.index_id
JOIN sys.columns col ON ic.object_id=col.object_id AND ic.column_id=col.column_id
GROUP BY tbl.name , col.name


SELECT 
SCHEMA_NAME(t.schema_id) AS SchemeName,
t.name AS TableName,
s.name AS StatisticName,
sp.last_updated AS LastUpdate,
DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
sp.rows AS 'ROWS',
sp.modification_counter AS ModificationSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id , s.stats_id) AS sp
ORDER BY
sp.modification_counter DESC

UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000001_6EF57B66

UPDATE STATISTICS sales.DBCustomers

EXEC sp_updatestats

--monitoring fragmentation
  SELECT * FROM sys.dm_db_index_physical_stats (DB_ID() , NULL,NULL,NULL,'LIMITED')

  SELECT 
  tbl.name AS tableName,
  idx.name AS IndexName,
  s.avg_fragmentation_in_percent,
  s.page_count
 FROM sys.dm_db_index_physical_stats (DB_ID() , NULL,NULL,NULL,'LIMITED') AS s
INNER JOIN sys.tables tbl
ON s.object_id=tbl.object_id
INNER JOIN sys.indexes AS idx
ON idx.object_id=s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC

ALTER INDEX idx_customers_country ON Sales.Customers REORGANIZE

ALTER INDEX idx_customers_country ON Sales.Customers REBUILD