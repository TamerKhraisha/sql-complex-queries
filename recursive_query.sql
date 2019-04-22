-- Database by Doug
-- Douglas Kline
-- 6/29/2016
-- Recursion

USE Northwind

-- data in the world is commonly *hierarchical*
-- this is modeled using a table that relates to itself in a 1-many manner
-- in other words, it has a foreign key that references itself

-- to get records from the entire hierarchy, we need recursion

SELECT *
FROM   Employees

-- focusing on just the columns of interest
SELECT   EmployeeID,
         LastName,
         reportsTo 
FROM     Employees
ORDER BY EmployeeID

-- notice that reportsTo is a foreign key
-- that references the primary key in
-- the same table
-- in other words, this relationship is
--   self-referential

-- maybe better like this:
SELECT   EmployeeID,
         LastName,
         reportsTo AS [employeeID of Boss]
FROM     Employees
ORDER BY EmployeeID

-- or
SELECT   EmployeeID,
         LastName,
         reportsTo AS [bossID]
FROM     Employees
ORDER BY EmployeeID


-- so to join a table to itself,
-- we need to use a table alias

SELECT   Employee.EmployeeID,
         Employee.LastName  AS [LastName],
         Employee.ReportsTo AS [ReportsToID],
         Boss.EmployeeID    AS [BossID],
         Boss.LastName      AS [Boss LastName]
FROM     Employees   AS [Employee]
  JOIN   Employees      AS [Boss]  ON Employee.ReportsTo = Boss.EmployeeID
ORDER BY Employee.EmployeeID

-- notice that we lost someone, employeeID=2, 
-- because their reportsTo was NULL
-- we can get them back with an outer JOIN

SELECT      Employee.EmployeeID,
            Employee.LastName  AS [LastName],
            Employee.ReportsTo AS [ReportsToID],
            Boss.EmployeeID    AS [BossID],
            Boss.LastName      AS [Boss LastName]
FROM        Employees          AS [Employee]
  LEFT JOIN Employees          AS [Boss] ON Employee.ReportsTo= Boss.EmployeeID
ORDER BY    Employee.EmployeeID

-- the above has been from the Employee perspective, and their bosses
-- lets do this the other way
-- Bosses, and their employees

SELECT      Boss.EmployeeID  AS [BossID],
            Boss.LastName  AS [Boss LastName],
            Employee.EmployeeID,
            Employee.LastName AS [LastName],
            Employee.ReportsTo AS [ReportsToID]
FROM        Employees   AS [Employee]
  LEFT JOIN Employees   AS [Boss] ON Employee.ReportsTo= Boss.EmployeeID
ORDER BY    Boss.EmployeeID

-- look closely, the JOIN hasn't changed
-- the only difference is the order of the columns
-- and the ORDER BY statement

-- both of the above only represent 
-- a single level in the hierarchy

-- an employee, and their direct supervisor
-- or a boss, and their direct supervisee

-- look at it another way
SELECT   Boss.EmployeeID    AS [BossID],
         Boss.LastName      AS [Boss LastName],
         COUNT(Employee.EmployeeID) AS [Supervisees]
FROM     Employees AS [Employee]
  JOIN   Employees AS [Boss] ON Employee.ReportsTo= Boss.EmployeeID
GROUP BY Boss.employeeID,
         Boss.LastName
ORDER BY Boss.EmployeeID

-- so this shows that Fuller has 5 *direct* reportees
-- and Buchanan has 3 direct reportees

-- however, Buchanan reportees to Fuller
-- so really, Fuller has 8 reportees "under him"

-- and with more full data, 
-- there could be many levels
-- in the hierarchy

-- to do this, we'll need a
-- Common Table Expression, aka CTE

-- clean version-----------------------------------
WITH EmployeesAndTheirBosses 
  (EmployeeID,
  LastName,
  ReportsTo,
  BossLastName,
  depth)
AS
(
SELECT  EmployeeID,
        LastName,
        ReportsTo,
        LastName,
        0 
FROM    Employees
WHERE   reportsTo IS NULL 

UNION ALL 

SELECT   Employees.EmployeeID,
         Employees.LastName,
         Employees.ReportsTo,
         EmployeesAndTheirBosses.LastName,
         EmployeesAndTheirBosses.depth + 1
FROM     Employees
   JOIN  EmployeesAndTheirBosses ON employees.reportsTo = EmployeesAndTheirBosses.EmployeeID
)

SELECT   *
FROM     EmployeesAndTheirBosses
ORDER BY depth




-- annotated version-----------------------------------

-- CTEs define a table that can be referenced in only
-- the very next statement
-- WITH defines what the table looks like: name and columns
WITH EmployeesAndTheirBosses 
         (EmployeeID,
          LastName,
          ReportsTo,
          BossLastName,
          depth)
AS
-- now define what records go into the CTE
(
-- PART A
SELECT   EmployeeID,
         LastName,
         ReportsTo,
         LastName,
         0 -- the person without a boss has a depth of zero
FROM     Employees
WHERE    reportsTo IS NULL -- no boss!
-- the part above is the base condition
-- it's the employee with no boss

UNION ALL -- the ALL part is important for the recursion to work

-- the part below is the recursion
-- PART B
SELECT   Employees.EmployeeID,
         Employees.LastName,
         Employees.ReportsTo,
         EmployeesAndTheirBosses.LastName,
         EmployeesAndTheirBosses.depth + 1
FROM     Employees
   JOIN  EmployeesAndTheirBosses ON employees.reportsTo = EmployeesAndTheirBosses.EmployeeID
   -- notice that this references the CTE: EmployeesAndTheirBosses
   -- this is the recursion
)
-- now that the CTE is defined, select records from it
-- the CTE only exists for this next SELECT statement
-- in other words, the scope of the CTE is the next statement
SELECT   *
FROM     EmployeesAndTheirBosses
ORDER BY depth

-- I've ordered the records by depth, 
-- so you can see the recursion easily

--EmployeeID  LastName             ReportsTo   BossLastName         depth
------------- -------------------- ----------- -------------------- -----------
--2           Fuller               NULL        Fuller               0
--1           Davolio              2           Fuller               1
--3           Leverling            2           Fuller               1
--4           Peacock              2           Fuller               1
--5           Buchanan             2           Fuller               1
--8           Callahan             2           Fuller               1
--6           Suyama               5           Buchanan             2
--7           King                 5           Buchanan             2
--9           Dodsworth            5           Buchanan             2
--11          Kline                6           Suyama               3
--12          Jones                11          Kline                4
--13          Johnson              11          Kline                4

-- think of the recursion happening this way:

--EmployeeID  LastName             ReportsTo   BossLastName         depth
------------- -------------------- ----------- -------------------- -----------
-- ** base condition ** 
--2           Fuller               NULL        Fuller               0
-- ** first level of recursion, all those who report to level above
--1           Davolio              2           Fuller               1
--3           Leverling            2           Fuller               1
--4           Peacock              2           Fuller               1
--5           Buchanan             2           Fuller               1
--8           Callahan             2           Fuller               1
-- ** second level of recursion, all those who report to first level employees
--6           Suyama               5           Buchanan             2
--7           King                 5           Buchanan             2
--9           Dodsworth            5           Buchanan             2
-- ** third level of recursion, all those who report to 2nd level employees
--11          Kline                6           Suyama               3
-- ** fourth level of recursion, all those who report to 3rd level employees
--12          Jones                11          Kline                4
--13          Johnson              11          Kline                4
-- ** fifth level of recursion, all those who report to 4th level employees
-- ** no one

-- STEP 1: Base condition
-- The base condition is from PART A
-- it returns only fuller
-- Fuller is the person with no boss; NULL for reportsTo
-- depth=0 by decision - we could use any number, zero makes sense

-- STEP 2: First level of recursion
-- This joins Part A and Part B
-- So it joins Fuller with all people who reportTo Fuller
-- These are the records with depth= 1
-- depth = depth of fuller plus 1

-- STEP 3: Second level of recursion
-- this Joins First level of recursion with all Employees
-- So it joins Davolio thru Callahan with all employees who report to them
-- These are the records with depth = 2
-- depth = depth of Davolio thru Callahan plus 1

-- STEP 4: Third level of recursion
-- this Joins second level of recursion with all Employees
-- this Joins Suyama thru Dodsworth with employees who report to them
-- These are the records with depth = 3

-- etc.

-- in this case, we only have 4 levels
-- but this would continue if there were more levels

-- Database by Doug
-- Douglas Kline
-- 6/29/2016
-- Recursion
