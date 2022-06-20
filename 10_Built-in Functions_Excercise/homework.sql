USE SoftUni
--1va

SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'Sa%'
--WHERE LEFT(FirstName, 2) = 'Sa'


--2ra
SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%'
--WHERE CHARINDEX('ei', LastName) <> 0

--3ta
SELECT FirstName FROM Employees
WHERE 
--DepartmentID = 3 or DepartmentID = 10
DepartmentID IN (3, 10)
or DATEPART(YEAR, HireDate) BETWEEN 1995 and 2005

--4ta
SELECT FirstName, LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

--5ta
SELECT [Name] FROM Towns
WHERE LEN(Name) IN(5, 6)
ORDER BY [Name]

--6ta
SELECT TownID, [Name] FROM Towns
WHERE 
 --LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
[Name] LIKE '[MKBE]%'
ORDER BY [NAME]

--7ma
SELECT TownID, Name FROM Towns
WHERE 
--[NAME] NOT LIKE 'R%' 
--AND [NAME] NOT LIKE 'B%'
--AND [NAME] NOT LIKE 'D%'
[NAME] NOT LIKE '[RBD]%' 
ORDER BY [NAME]

--8ma

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE DATEPART(YEAR,HireDate) > 2000

--9ta
SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5

--10ta
SELECT EmployeeID, FirstName, LastName, Salary, DENSE_RANK() OVER
(PARTITION BY Salary ORDER BY EmployeeID) AS Rank
FROM Employees
WHERE  Salary  BETWEEN 10000 AND 50000
 ORDER BY Salary DESC

 --11ta
 SELECT * 
 FROM (
 SELECT EmployeeID, FirstName, LastName, Salary, DENSE_RANK() OVER
(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE  Salary  BETWEEN 10000 AND 50000
 
 ) AS RankingSubquery
 WHERE [Rank] = 2
  ORDER BY Salary DESC


USE Geography
--12ta
SELECT CountryName, IsoCode FROM 
Countries
WHERE LOWER(CountryName) LIKE '%a%a%a%'
ORDER BY IsoCode

--13ta
SELECT p.PeakName, r.RiverName, 
LOWER(CONCAT(LEFT(p.PeakName,LEN(p.PeakName)-1), r.RiverName)) as Mix
FROM Rivers as r, Peaks as p
WHERE RIGHT(p.PeakName,1) = LEFT(r.RiverName, 1)
ORDER BY Mix

--14ta
USE Diablo
SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd')  as [Start] FROM Games
WHERE DATEPART(YEAR,[Start]) IN (2011,2012)
ORDER BY [Start], [Name]

--15ta
SELECT Username
, SUBSTRING([Email], CHARINDEX('@', [Email])+1, LEN([Email])) AS 'Email Provider' From Users
ORDER BY [Email Provider], Username

--16ta
SELECT Username, IpAddress as [IP Address] FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--17ta
SELECT [Name] as Game,
CASE
	WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
	WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
	WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
	END
as [Part of the Day], 
CASE
	WHEN [Duration] <=3 THEN 'Extra Short'
	WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
	WHEN [Duration] > 6 THEN 'Long'
	ELSE 'Extra Long'
END as Duration
FROM Games
ORDER BY Game, Duration

--18ta
USE Demo

CREATE TABLE Orders( 
Id INT IDENTITY NOT NULL
,ProductName NVARCHAR(30) NOT NULL
,OrderDate DATETIME2
)
INSERT INTO Orders
VALUES
('Butter', '2016-09-19 00:00:00.000')
,('Milk', '2016-09-30 00:00:00.000')
,('Cheese', '2016-09-04 00:00:00.000')
,('Bread', '2015-12-20 00:00:00.000')
,('Tomatoes', '2015-12-30 00:00:00.000')

SELECT 
ProductName
, OrderDate
,  DATEADD(DAY, 3, OrderDate) as [Pay Due]
,  DATEADD(MONTH, 1, OrderDate) as [Deliver Due]
FROM Orders

