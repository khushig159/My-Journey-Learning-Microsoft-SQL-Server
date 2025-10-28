--TRIGEERS--> special stored procedure that automatically runs in response to specific event on a table or view

--types--> 1.DML, 2.DDL, 3.LOGGON

--DML--> AFTER AND INSTEAD OF
--AFTER--> RUNS AFTER EVENT
--INSEAD OF-->RUNS DURING EVENT

--step1. create log table

--CREATE TABLE Sales.EmployeeLogs(
--LogID INT IDENTITY(1,1) PRIMARY KEY,
--EmployeeID INT,
--LogMessage VARCHAR(255),
--LogDate DATE
--)

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS 
BEGIN
INSERT INTO Sales.EmployeeLogs(EmployeeID,LogMessage,LogDate)
SELECT	
	EmployeeID,
	'New EMployee Added=' + CAST(EmployeeID AS VARCHAR),
	GETDATE()
FROM INSERTED
END

