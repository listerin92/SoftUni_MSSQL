USE Gringotts
GO

--1
SELECT COUNT(*) AS Count FROM WizzardDeposits

--2
SELECT MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits

--3
SELECT
DepositGroup
, MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

--4 
SELECT TOP 2
		DepositGroup
		FROM WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize)

--5
SELECT 
DepositGroup
,SUM(DepositAmount) AS TotalSum
FROM 
WizzardDeposits
GROUP BY DepositGroup

--6
	  SELECT DepositGroup
			,SUM(DepositAmount) AS TotalSum
		FROM WizzardDeposits
	   WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

--7
	  SELECT DepositGroup
			,SUM(DepositAmount) AS TotalSum
		FROM WizzardDeposits
	   WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	  HAVING SUM(DepositAmount) < 150000
	ORDER BY TotalSum DESC

--8
	 SELECT DepositGroup
	    	,MagicWandCreator
			,MIN(DepositCharge) AS MinDepositCharge
	  FROM WizzardDeposits
  GROUP BY DepositGroup, MagicWandCreator
  ORDER BY MagicWandCreator, DepositGroup

--9
SELECT AgeRange.AgeRange
	,COUNT(*) AS WizzardCount
FROM (SELECT 
		CASE 
			WHEN Age BETWEEN 0 AND 10 THEN '[0-10]' 
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]' 
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]' 
			WHEN Age BETWEEN 31 AND 40 THEN '[31-40]' 
			WHEN Age BETWEEN 41 AND 50 THEN '[41-50]' 
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]' 
			ELSE '[61+]'
		  END AS AgeRange
		FROM WizzardDeposits
		) AS AgeRange
	GROUP BY AgeRange

--10
	SELECT * FROM
	(
	  SELECT 
		SUBSTRING(FirstName,1,1) AS FirstLetter
		 FROM WizzardDeposits
		WHERE DepositGroup = 'Troll Chest') AS tc
	 GROUP BY tc.FirstLetter

--11
		SELECT 
				DepositGroup
				,IsDepositExpired
				,AVG(DepositInterest) AS AverageInterest
			FROM WizzardDeposits
		   WHERE DepositStartDate > '1985-01-01'
		GROUP BY DepositGroup, IsDepositExpired
		ORDER BY DepositGroup DESC, IsDepositExpired

--12

SELECT SUM([Difference]) AS [SumDifference] FROM
(
		SELECT *
			  ,[Host Wizard Deposit] - [Guest Wizzard Deposit] AS [Difference] FROM
		(
		SELECT a.[Host Wizard]
			  ,a.[Host Wizard Deposit],otherWd.FirstName AS [Guest Wizzard]
			  ,otherWd.DepositAmount AS [Guest Wizzard Deposit]
		FROM
	 (SELECT wd.Id,wd.FirstName AS [Host Wizard]
	        ,wd.DepositAmount AS [Host Wizard Deposit] 
		FROM WizzardDeposits AS [wd])  AS A, 
		WizzardDeposits AS [otherWd]
	   WHERE a.Id +1 = otherWd.Id) AS SumDifferenceColumns)
	   AS SumDifference

USE SoftUni
GO

--13
	  SELECT DepartmentID
			 ,SUM(Salary) AS TotalSalary
		FROM Employees AS e
	GROUP BY DepartmentID
	ORDER BY DepartmentID


--14
	   SELECT DepartmentID
			 ,MIN(Salary) AS MinimumSalary
		FROM Employees
		WHERE DepartmentID IN (2,5,7)
	 GROUP BY DepartmentID

--15
	 SELECT * 
	   INTO TempTable
	   FROM Employees
	   WHERE Salary > 30000
	
	DELETE 
	  FROM TempTable
	 WHERE ManagerID = 42

	 UPDATE TempTable
		SET Salary = Salary + 5000
	  WHERE DepartmentID = 1

	SELECT DepartmentID
		   ,AVG(Salary) 
	  FROM TempTable
  GROUP BY DepartmentID

 --16
		SELECT DepartmentID
			  ,MAX(Salary) AS MaxSalary
		  FROM Employees
	  GROUP BY DepartmentID
	    HAVING MAX(Salary) <30000 OR MAX(Salary) > 70000

--17
	  SELECT COUNT(*)	AS Count
		FROM Employees
	GROUP BY ManagerID
	  HAVING ManagerID IS NULL

--18
		SELECT DISTINCT er.DepartmentID
			, er.Salary AS ThirdHighestSalary
		FROM 
	 (SELECT *
			,DENSE_RANK() OVER (Partition BY DepartmentID ORDER BY Salary DESC) AS rn
		FROM Employees) AS er
		WHERE er.rn = 3
	ORDER BY DepartmentID

--19
