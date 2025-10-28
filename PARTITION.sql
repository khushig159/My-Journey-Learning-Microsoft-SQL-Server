--create partition function

CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES('2023-12-31','2024-12-31','2025-12-31')

--Query lists all existing partition function
SELECT 
name,
function_id,
type,
type_desc,
boundary_value_on_right
FROM sys.partition_functions

--create filegroups

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026


--uery lists all existing filegroups
SELECT * FROM sys.filegroups WHERE type='FG'

--add file to each filegroup
ALTER DATABASE SalesDB ADD FILE
(
NAME = P_2023, ---logical name
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS03\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023

ALTER DATABASE SalesDB ADD FILE
(
NAME = P_2024, ---logical name
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS03\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024

ALTER DATABASE SalesDB ADD FILE
(
NAME = P_2025, ---logical name
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS03\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025

ALTER DATABASE SalesDB ADD FILE
(
NAME = P_2026, ---logical name
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS03\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026

SELECT 
fg.name AS FileGroupName,
mf.name AS LogicalFileName,
mf.physical_name AS PhysicalFilePath,
mf.size / 128 AS SizeInMB
FROM 
sys.filegroups fg
JOIN sys.master_files mf ON fg.data_space_id=mf.data_space_id
WHERE mf.database_id=DB_ID('SalesDB')

--create partition scheme

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO  (FG_2023,FG_2024,FG_2025,FG_2026)

--query lists all partition scheme
SELECT
ps.name AS PartitionSchemeName,
pf.name AS PartitionFunctionName,
ds.destination_id AS PartitionNumber,
fg.name AS FileGroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id=pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id=ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id=fg.data_space_id

--create the partitioned table
CREATE TABLE Sales.Order_partioned
(
OrderId INT,
OrderDate DATE,
Sales INT
) ON SchemePartitionByYear (OrderDate)

--insert data into partioned table
INSERT INTO Sales.Order_partioned VALUES (1,'2023-05-15',100)
INSERT INTO Sales.Order_partioned VALUES (2,'2024-05-15',100)

SELECT * FROM Sales.Order_partioned

SELECT 
p.partition_number AS PartitionNumber,
f.name AS PartitionFilegroup,
p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number=dds.destination_id
JOIN sys.filegroups f on dds.data_space_id=f.data_space_id
WHERE OBJECT_NAME(p.object_id)='Order_partioned';