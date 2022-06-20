CREATE DATABASE Zoo
GO
USE Zoo
GO

--1
CREATE TABLE Owners
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50)
)

CREATE TABLE AnimalTypes
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	AnimalTypeId INT FOREIGN KEY REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE Animals
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	OwnerId INT FOREIGN KEY REFERENCES Owners(Id),
	AnimalTypeId INT FOREIGN KEY REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE AnimalsCages
(
	CageId INT FOREIGN KEY REFERENCES Cages(Id) NOT NULL,
	AnimalId INT FOREIGN KEY REFERENCES Animals(Id) NOT NULL,
	PRIMARY KEY(CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50),
	AnimalId INT FOREIGN KEY REFERENCES Animals(Id),
	DepartmentId INT FOREIGN KEY REFERENCES VolunteersDepartments(Id) NOT NULL
)

--2
INSERT INTO Volunteers([Name], PhoneNumber, [Address], AnimalId, DepartmentId)
VALUES
('Anita Kostova', '	0896365412', 'Sofia, 5 Rosa str.', 15, 1),
('Dimitur Stoev', '0877564223', null, 42, 4),
('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva', '0888112233',null , 	31, 5)

INSERT INTO Animals([Name], BirthDate, OwnerId, AnimalTypeId)
VALUES
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', 	null, 1),
('Tuatara', '2021-06-30', 2, 4)

--3
UPDATE Animals
SET OwnerId = 4
WHERE OwnerId IS NULL

--4
ALTER TABLE Volunteers
	ALTER COLUMN 
		DepartmentId INT NULL

UPDATE Volunteers
SET DepartmentId = NULL
WHERE DepartmentId = 2

DELETE FROM VolunteersDepartments
WHERE Id = 2

--5
	SELECT [Name]
		   ,PhoneNumber
		   ,[Address]
		   ,AnimalId
		   ,DepartmentId
	  FROM Volunteers
  ORDER BY [Name], AnimalId, DepartmentId

--6
	SELECT a.[Name]
		   ,att.AnimalType
		   ,FORMAT(a.BirthDate, 'dd.MM.yyyy') AS BirthDate
	  FROM Animals 
	    AS a
	  JOIN AnimalTypes
	    AS att ON a.AnimalTypeId = att.Id
  ORDER BY a.[Name]

--7
	SELECT TOP 5
		   o.[Name] AS [Owner]
		   ,COUNT(a.Id) AS 'CountOfAnimals'
	  FROM Animals AS a
	  JOIN Owners As o ON a.OwnerId = o.Id
	  GROUP BY o.[Name]
	  ORDER BY COUNT(a.Id) DESC, o.[Name]

--8
	SELECT CONCAT(o.[Name], '-', a.[Name]) AS OwnersAnimals
		   ,o.PhoneNumber
		   ,ac.CageId
	  FROM Animals AS a
	  JOIN Owners AS o ON a.OwnerId = o.Id
	  JOIN AnimalsCages AS ac ON a.Id = ac.AnimalId
	  JOIN Cages AS c ON ac.CageId = c.Id
	  JOIN AnimalTypes AS att ON a.AnimalTypeId = att.Id
	  WHERE att.Id = 1
	  ORDER BY o.[Name], a.[Name] DESC

--9
	SELECT  v.[Name]
			, v.PhoneNumber
			,LTRIM(SUBSTRING(v.Address, CHARINDEX(',', v.Address)+1, 50)) AS [Address]
	  FROM Volunteers AS v
	  JOIN VolunteersDepartments AS vd ON v.DepartmentId = vd.Id
	  WHERE vd.Id = 2 AND TRIM(SUBSTRING(v.Address, 1, CHARINDEX(',', v.Address)-1)) = 'Sofia'
	  ORDER BY v.[Name]

--10
	SELECT a.[Name]
		   ,YEAR(a.BirthDate) AS BirthYear
		   --,DATEDIFF(YEAR, a.BirthDate, '2022/01/01')
		   ,att.AnimalType
	  FROM Animals AS a
	JOIN AnimalTypes AS att ON a.AnimalTypeId = att.Id
	WHERE OwnerId IS NULL AND DATEDIFF(YEAR, a.BirthDate, '2022/01/01') < 5 AND att.Id !=3
	ORDER BY a.[Name]

--11
	CREATE OR ALTER FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(50))
		RETURNS INT
		BEGIN
		DECLARE @RESULT INT
			SET @RESULT = (SELECT COUNT(v.Id) FROM Volunteers AS v
			JOIN VolunteersDepartments AS vd ON v.DepartmentId = vd.Id
			WHERE vd.DepartmentName = @VolunteersDepartment)
			RETURN @RESULT
		END

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Guest engagement')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Zoo events')

--12
	CREATE PROC usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(50))
		AS
			BEGIN
				SELECT a.[Name]
						,CASE WHEN a.OwnerId IS NULL THEN 'For adoption'
								ELSE o.Name END AS OwnersName
						FROM Animals AS a
				LEFT JOIN Owners AS o ON a.OwnerId = o.Id
				WHERE a.[Name] = @AnimalName
			END

EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish'
EXEC usp_AnimalsWithOwnersOrNot 'Hippo'
EXEC usp_AnimalsWithOwnersOrNot 'Brown bear'