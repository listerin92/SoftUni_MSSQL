CREATE DATABASE [Service]
GO
USE [Service]
GO

CREATE TABLE Users
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	[Name] VARCHAR(50),
	Birthdate DATETIME,
	Age INT CHECK(Age BETWEEN 14 AND 110),
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Employees
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate DATETIME,
	Age INT CHECK(Age BETWEEN 18 AND 110),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL
)

CREATE TABLE Categories
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL
)

CREATE TABLE [Status]
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Label] VARCHAR(30) NOT NULL,
)

CREATE TABLE Reports
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	StatusId INT FOREIGN KEY REFERENCES [Status](Id) NOT NULL,
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME,
	[Description] VARCHAR(200) NOT NULL,
	UserId INT FOREIGN KEY REFERENCES [Users](Id) NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
)

--2
INSERT INTO Employees(FirstName, LastName, Birthdate, DepartmentId)
VALUES
('Marlo',	'O''Malley', 1958-9-21,	1),
('Niki', 'Stanaghan', 1969-11-26, 4),
('Ayrton',	'Senna', 1960-03-21, 9),
('Ronnie', 'Peterson', 1944-02-14, 9),
('Giovanna', 'Amati', 1959-07-20, 5)

INSERT INTO Reports(CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId)
VALUES
(1, 1, 2017-04-13, NULL, 'Stuck Road on Str.133', 6, 2),
(6,	3,	2015-09-05,	2015-12-06,	'Charity trail running', 3,	5),
(14, 2,	2015-09-07,	NULL, 'Falling bricks on Str.58', 5, 2),
(4,	3, 2017-07-03, 2017-07-06, 'Cut off streetlight on Str.11',	1, 1)

--3
UPDATE Reports
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL

--4
		DELETE FROM Reports 
		WHERE StatusId = 4

--5
		SELECT [Description]
			   ,FORMAT(OpenDate, 'dd-MM-yyyy') AS OpenDate
		  FROM Reports
		 WHERE EmployeeId IS NULL
	  ORDER BY FORMAT(OpenDate, 'yyyy-MM-dd'), [Description]

--6
	SELECT r.[Description]
		   ,c.[Name] AS CategoryName
	  FROM Reports AS r
	  JOIN Categories AS c ON r.CategoryId = c.Id
  ORDER BY r.[Description], c.[Name]

--7
	SELECT TOP 5
			c.[Name]
			,COUNT(r.CategoryId) AS ReportsNumber
		FROM Categories AS c
		JOIN Reports AS r ON c.Id = r.CategoryId
	GROUP BY c.[Name]
	ORDER BY COUNT(r.CategoryId) DESC, c.[Name]

--8
	SELECT u.Username
		   ,c.[Name] AS CategoryName
	  FROM Reports AS r
	  JOIN Users AS u ON r.UserId = u.Id
	  JOIN Categories as c ON r.CategoryId = c.Id
	 WHERE DATEPART(DAY,r.OpenDate) = DATEPART(DAY, u.Birthdate)
	 ORDER BY u.Username, CategoryName

--9
  SELECT temp.FullName
		,COUNT(temp.EmployeeId)	AS UserCount
		FROM
    (SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName
		    ,r.EmployeeId
	   FROM Employees AS e
	   LEFT JOIN Reports AS r ON r.EmployeeId = e.Id
	   LEFT JOIN Users AS u ON r.UserId = u.Id) AS temp
   GROUP BY temp.FullName
   ORDER BY UserCount DESC, temp.FullName

 --10
	SELECT 
	CASE WHEN e.FirstName IS NULL THEN 'None'
		 WHEN e.LastName IS NULL THEN 'None' 
		 ELSE CONCAT(e.FirstName, ' ', e.LastName) END AS Employee
		   ,CASE WHEN d.Name IS NULL THEN 'None' ELSE d.Name END AS Department
		   ,c.Name AS Category
		   ,r.Description
		   ,FORMAT(r.OpenDate, 'dd.MM.yyyy') AS OpenDate
		   ,s.Label AS [Status]
		   ,u.Name AS [User]
	  FROM Reports AS r
	  LEFT JOIN Employees AS e ON r.EmployeeId = e.Id
	  LEFT JOIN Departments AS d ON e.DepartmentId = d.Id
	  JOIN [Status] AS s ON r.StatusId = s.Id
	  JOIN Users AS u ON r.UserId = u.Id
	  JOIN Categories AS c ON r.CategoryId = c.Id
  ORDER BY e.FirstName DESC,
		   e.LastName DESC,
		   Department,
		   Category,
		   [Description],
		   OpenDate,
		   [Status],
		   [User]

--11

		CREATE OR ALTER FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
			RETURNS INT
			BEGIN
				DECLARE @RESULT INT
				SET @RESULT = DATEDIFF(HOUR, @StartDate, @EndDate)
				IF @StartDate IS NULL BEGIN SET @RESULT = 0 END
				IF @EndDate IS NULL BEGIN SET @RESULT = 0 END


				RETURN @RESULT
			END

			SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours
			  FROM Reports
   
--12
		CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
			AS
			BEGIN
				DECLARE @eDeptId INT
				DECLARE @repCatDeptId INT

					SET @eDeptId = (SELECT DISTINCT d.Id FROM Reports AS r 
					JOIN Employees AS e ON r.EmployeeId = e.Id
					JOIN Departments AS d ON e.DepartmentId = d.Id
					WHERE e.Id = @EmployeeId)

					SET @repCatDeptId = (SELECT DISTINCT c.DepartmentId FROM Reports AS r
					JOIN Categories AS c ON r.CategoryId = c.Id
					WHERE r.Id = @ReportId)

				IF(@eDeptId != @repCatDeptId) 
				BEGIN
					THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1; 
				END

				UPDATE Reports 
				SET EmployeeId = @EmployeeId
				WHERE Id = @ReportId
			END
		EXEC usp_AssignEmployeeToReport 30, 1