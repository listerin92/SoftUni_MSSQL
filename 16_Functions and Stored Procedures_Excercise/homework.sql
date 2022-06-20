--1
CREATE PROC usp_GetEmployeesSalaryAbove35000 
AS
	SELECT FirstName
		   ,LastName
	   FROM Employees
	WHERE Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000 

--2
CREATE PROC usp_GetEmployeesSalaryAboveNumber (@Number DECIMAL(18,4))
AS
	SELECT FirstName
		   ,LastName
	   FROM Employees
	WHERE Salary >= @Number

EXEC usp_GetEmployeesSalaryAboveNumber 48100

--3
CREATE PROC usp_GetTownsStartingWith (@input VARCHAR(50))
AS
	SELECT [Name] AS Town FROM Towns
	WHERE [Name] LIKE @input + '%'

EXEC usp_GetTownsStartingWith 'b'

--4

CREATE PROC usp_GetEmployeesFromTown (@TownName VARCHAR(50))
AS
	SELECT e.FirstName AS 'First Name'
		   ,e.LastName AS 'Last Name'
	   FROM Employees AS e
	   JOIN Addresses AS a ON e.AddressID = a.AddressID
	   JOIN Towns AS t ON a.TownID = t.TownID
	  WHERE t.[Name] = @TownName

	EXEC usp_GetEmployeesFromTown  'Sofia'

--5
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS NVARCHAR(10) AS
BEGIN
	DECLARE @salaryLevel NVARCHAR(10)
IF (@salary < 30000)
    SET @salaryLevel = 'Low'
ELSE IF(@salary <= 50000)
    SET @salaryLevel = 'Average'
ELSE
    SET @salaryLevel = 'High'
RETURN @salaryLevel

	RETURN @salaryLevel
END

SELECT Salary, 
dbo.ufn_GetSalaryLevel(Salary) AS 'Salary Level'
FROM Employees

--6
CREATE PROC usp_EmployeesBySalaryLevel (@LevelOfSalary VARCHAR(10))
AS
SELECT FirstName AS 'First Name'
	  ,LastName AS 'Last Name'
  FROM Employees
 WHERE dbo.ufn_GetSalaryLevel(Salary) = @LevelOfSalary

 EXEC usp_EmployeesBySalaryLevel 'High'

 --7
 GO

 CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(10), @word VARCHAR(10)) 
 RETURNS BIT AS
	 BEGIN 
	 DECLARE @Result BIT
	 SET @Result = CAST(PATINDEX('%'+ '['+@word+']', @setOfLetters) AS BIT)
		RETURN @Result
	 END

	DECLARE @word VARCHAR(10) = 'Sofia'
 SELECT dbo.ufn_IsWordComprised('oistmiahf','Sofia') AS Result

 --8
 CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
 AS
 BEGIN
		DELETE FROM EmployeesProjects
			  WHERE EmployeeID IN (
									 SELECT EmployeeID 
									   FROM Employees
									  WHERE DepartmentID = @departmentId
								  )

		UPDATE Employees
		   SET ManagerID = NULL
		 WHERE ManagerID IN (
									 SELECT EmployeeID 
									   FROM Employees
									  WHERE DepartmentID = @departmentId
								  )

		ALTER TABLE Departments
		ALTER COLUMN ManagerID INT

		UPDATE Departments
		   SET ManagerID  = NUll
		 WHERE ManagerID IN (
		 							SELECT EmployeeID 
									FROM Employees
									WHERE DepartmentID = @departmentId
								)


		DELETE FROM Employees
			  WHERE DepartmentID = @departmentId

		DELETE FROM Departments
			  WHERE DepartmentID = @departmentId

	   SELECT COUNT(EmployeeID) 
		   	   FROM Employees
			  WHERE DepartmentID = @departmentId
 END
 
 --9
 CREATE PROC usp_GetHoldersFullName 
 AS
	 BEGIN
		 SELECT CONCAT(FirstName, ' ', LastName) 
		   FROM AccountHolders
	 END

--10

	CREATE TABLE AccountHolders
	(Id [int] PRIMARY KEY IDENTITY(1,1) NOT NULL
	,FirstName [varchar](50) NOT NULL
	,LastName [varchar](50) NOT NULL
	,SSN [varchar](50) NOT NULL)
	
	CREATE TABLE Accountss
	(Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	AccountHolderId INT , 
	Balance DECIMAL(18,4))

	ALTER TABLE Accountss  WITH CHECK ADD  CONSTRAINT [FK_Accounts_AccountHolders] FOREIGN KEY([AccountHolderId])
	REFERENCES [dbo].AccountHolders ([Id])

INSERT INTO AccountHolders(FirstName, LastName, SSN)
VALUES
('Monika', 'Miteva', 'asdf1234')
,('Petar', 'Kirilov', 'asdf1234')
INSERT INTO AccountHolders(FirstName, LastName, SSN)
VALUES
('Susan', 'Cane', 'asdf4321')
INSERT INTO Accountss(AccountHolderId, Balance)
VALUES
(1, 11000)
,(1, 9000)
,(2, 21000)
,(2, 9000)
INSERT INTO Accountss(AccountHolderId, Balance)
VALUES
(3, 123.12)


--10
CREATE PROC usp_GetHoldersWithBalanceHigherThan (@number DECIMAL(18,4))
AS
	BEGIN
		SELECT ah.FirstName AS 'First Name'
			   ,ah.LastName AS 'Last Name'
		  FROM AccountHolders AS ah
		  JOIN Accounts AS a ON ah.Id = a.AccountHolderId
	  GROUP BY ah.FirstName, ah.LastName, a.AccountHolderId
	    HAVING  SUM(a.Balance) > @number
		ORDER BY ah.FirstName, ah.LastName
	END

--11
CREATE FUNCTION ufn_CalculateFutureValue (@Sum DECIMAL(18,4), @YearlyInterestRate FLOAT, @Years INT)
RETURNS DECIMAL (18,4)
AS
	BEGIN
		DECLARE @FV DECIMAL (18,4);
		DECLARE @TMP FLOAT;
		SET @TMP = 1 + @YearlyInterestRate;
		SET @FV = @Sum * POWER(@TMP ,@Years);
		RETURN @FV
	END

	SELECT dbo.ufn_CalculateFutureValue(123.12, 0.1, 5)

--12
 
 CREATE PROC usp_CalculateFutureValueForAccount(@AccountId INT, @interest FLOAT)
 AS
 BEGIN
		SELECT  ah.Id AS 'Account Id'
			   ,ah.FirstName AS 'First Name'
			   ,ah.LastName AS 'Last Name'
			   ,FORMAT(a.Balance, 'N2') AS 'Current Balance'
			   ,dbo.ufn_CalculateFutureValue(a.Balance, @interest, 5) AS 'Balance in 5 years'
		  FROM AccountHolders AS ah
		  JOIN Accounts AS a ON ah.Id = a.AccountHolderId
		  WHERE ah.Id = @AccountId 
END

EXEC usp_CalculateFutureValueForAccount 3, 0.1