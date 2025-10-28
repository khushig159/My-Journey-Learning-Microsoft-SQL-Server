--WRITE QUERY
--for US customers, find total number of customers and avg score

--CREATE PROCEDURE GetCustomerSummary AS
--BEGIN
--SELECT 
--COUNT(*) TotalCustomers,
--AVG(Score) AvgScore
--FROM Sales.Customers
--WHERE Country='USA'
--END
 
--execute
--EXEC GetCustomerSummary

--parameters==>placeholders used to pass values as input form the caller to procedure allowing dunamic data to be processed

--FIND THE TOTAL NUMBER OF ORDETS AND TOTAL SALES

DROP PROCEDURE IF EXISTS Sales.GetCustomerSummary;
GO 

CREATE PROCEDURE Sales.GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN

	BEGIN TRY

	DECLARE @TotalCustomers INT, @AvgScore Float;  --declare

	--PREPARE CLEANUP DATA
	--SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country ='Germany'

	IF EXISTS(SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country =@Country)
	BEGIN
		Print('Updating Null scores to zeeo');
		UPDATE Sales.Customers
		SET Score=0
		WHERE Score IS NULL AND Country=@Country;
	END

	ELSE
	BEGIN
		PRINT('No null');
	END;

	--GENERATING REPORT
	SET NOCOUNT ON; -- best practice to avoid extra result sets

	---variables then no alias

	SELECT 
		@TotalCustomers = COUNT(*),
		@AvgScore= AVG(Score) 
	FROM Sales.Customers
	WHERE Country=@Country;

	PRINT 'Total Customers from' +  @Country + ':'+ CAST(@TotalCustomers AS NVARCHAR);
	PRINT 'Average Score from' +  @Country + ':'+ CAST(@AvgScore AS NVARCHAR);

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales,
		1/0
	FROM Sales.Orders o
		JOIN Sales.Customers c
		ON c.CustomerID=o.CustomerID
	WHERE c.Country= @Country;

	END TRY

	BEGIN CATCH 
		PRINT('AN ERROR OCCURED');
		PRINT('ERROR MESSAGE:' + ERROR_MESSAGE());
		PRINT('ERROR MESSNUMBERAGE:' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('ERROR LINE:' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('ERROR PROCEDURE:' + CAST(ERROR_PROCEDURE() AS NVARCHAR));
	END CATCH

END
GO
 
EXEC Sales.GetCustomerSummary
EXEC Sales.GetCustomerSummary @Country='Germany'

--DROP PROCEDURE GetCustomerSummary

--Variable-->placeholder used to store values to be used later in procedure


--here we learned
--how to make procedure, pass arguements, declare and use variables, print statement and using try catch and cleaning up data using if else