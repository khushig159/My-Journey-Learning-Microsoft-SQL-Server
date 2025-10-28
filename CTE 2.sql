-- generate sequence of numbers from 1 to 20
;WITH Series AS (
    -- Anchor query
    SELECT 1 AS MyNumber
    UNION ALL
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 20
)
-- Main Query
SELECT *
FROM Series
OPTION (MAXRECURSION 20);


-- show the employee hierarchy by displaying each employee's level within the organization
;WITH CTE_EmpHierarchy AS (
    -- Anchor query: top-level employees
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive query: employees reporting to above
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        ceh.Level + 1
    FROM Sales.Employees AS e
    INNER JOIN CTE_EmpHierarchy ceh
        ON e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT * 
FROM CTE_EmpHierarchy;
