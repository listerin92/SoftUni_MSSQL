--1
USE SoftUni

SELECT TOP 5
e.EmployeeID AS EmployeeId
,e.JobTitle
,e.AddressID AS AddressId
,a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY a.AddressID

--2
SELECT TOP 50
e.FirstName
,e.LastName
,t.[Name] AS Town
,a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName

--3
SELECT 
e.EmployeeID
,e.FirstName
,e.LastName
,d.[Name] AS DepartmentName
FROM
Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID

--4
SELECT TOP 5
e.EmployeeID
,e.FirstName
,e.Salary
,d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY d.DepartmentID

--5
SELECT TOP 3
e.EmployeeID
,e.FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE ep.EmployeeID IS Null
ORDER BY e.EmployeeID

--6
SELECT 
e.FirstName
,e.LastName
,e.HireDate
,d.[Name] AS DeptName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > 1999-01-01 AND d.Name IN('Sales', 'Finance')
ORDER BY e.HireDate

--7
SELECT TOP 5
e.EmployeeID
,e.FirstName
,p.Name AS ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > 2022-08-13 AND p.EndDate IS NULL
ORDER BY e.EmployeeID

--8 ne e gotova
SELECT 
e.EmployeeID
,e.FirstName
,CASE
WHEN p.StartDate >= '2005-01-01' THEN NULL
ElSE p.Name
END AS ProjectName

FROM Employees AS e
JOIN EmployeesProjects AS ep ON  e.EmployeeID = ep.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

--9ta 
SELECT 
e.EmployeeID
,e.FirstName
,e.ManagerID
,m.FirstName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

--10
SELECT TOP 50
e.EmployeeID
,CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName
,CONCAT(m.FirstName, ' ', m.LastName ) AS ManagerName
,d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

--11
SELECT MIN(a.AverageSalary) AS MinAverageSalary
FROM
(
SELECT AVG(e.Salary) AS AverageSalary
FROM Employees AS e
GROUP BY DepartmentID 
) AS a

--12
USE Geography

SELECT 
c.CountryCode
,m.MountainRange
,p.PeakName
,p.Elevation
FROM Countries AS c
JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON mc.MountainId = m.Id
JOIN Peaks AS p ON mc.MountainId = p.MountainId
WHERE c.CountryName = 'Bulgaria' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--13
 SELECT
 mc.CountryCode
,COUNT(m.MountainRange) AS MountainRanges
 FROM MountainsCountries AS mc
 JOIN Mountains AS m ON mc.MountainId = m.Id
 WHERE mc.CountryCode IN('BG', 'RU', 'US')
GROUP By mc.CountryCode

--14
SELECT TOP 5
c.CountryName
,r.RiverName
	FROM Countries as c
		JOIN Continents AS cc ON c.ContinentCode = cc.ContinentCode
		LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
		LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
	WHERE cc.ContinentName = 'Africa'	
ORDER BY c.CountryName

--15 not ready
SELECT 
ContinentCode
,CurrencyCode
,CurrencyUsage
	FROM
	(SELECT *
	,DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC) 
		AS CurrencyRank
		FROM
			(SELECT co.ContinentCode
					,c.CurrencyCode
					,COUNT(c.CurrencyCode) AS CurrencyUsage
						FROM 
						Continents AS co
						LEFT JOIN Countries as c ON co.ContinentCode = c.ContinentCode
						GROUP BY co.ContinentCode, c.CurrencyCode
						) AS CurrencyUsageQuerry
				WHERE CurrencyUsage > 1
			) AS CurrencyRankingQuerry
		WHERE CurrencyRank = 1
ORDER BY ContinentCode

--16
SELECT COUNT(c.CountryName) AS [Count] 
	FROM Countries AS c
		LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		LEFT JOIn Mountains AS m ON mc.MountainId = m.Id
WHERE mc.MountainId IS NULL

--17

SELECT TOP 5
C.CountryName
, MAX(p.Elevation) AS HighestPeakElevation
, MAX(r.Length) AS LongestRiverLength
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p ON m.Id = p.MountainId
JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
GROUP By C.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC