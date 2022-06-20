CREATE DATABASE Airport
GO
USE Airport
GO

--1
CREATE TABLE Passengers
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FullName VARCHAR(100) NOT NULL,
	Email VARCHAR(50) NOT NULL,
)

CREATE TABLE Pilots
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(30) UNIQUE NOT NULL,
	LastName VARCHAR(30) UNIQUE NOT NULL,
	Age TINYINT CHECK(Age BETWEEN 21 AND 62) NOT NULL,
	Rating FLOAT CHECK (Rating BETWEEN 0.0 AND 10.0)
)

CREATE TABLE AircraftTypes
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT,
	Condition CHAR NOT NULL,
	TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft
(
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PilotId INT FOREIGN KEY REFERENCES Pilots(Id) NOT NULL,
	PRIMARY KEY (AircraftId, PilotId)
)

CREATE TABLE Airports
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	AirportName VARCHAR(70) UNIQUE NOT NULL,
	Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
	[Start] DATETIME DEFAULT GETDATE() NOT NULL,
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	TicketPrice DECIMAL(18,2) DEFAULT 15 NOT NULL
)

--2
INSERT INTO Passengers 
SELECT CONCAT(FirstName, ' ', LastName) AS FullName,
CONCAT(FirstName, LastName,'@gmail.com') AS Email
FROM Pilots AS pa
WHERE Id BETWEEN 5 AND 15

--3
UPDATE Aircraft
SET Condition = 'A'
WHERE Condition LIKE '[CB]' 
AND (FlightHours IS NULL OR FlightHours <= 100) 
AND [Year] >= 2013

--4
DELETE FROM Passengers
WHERE LEN(FullName) <=10

--5
		  SELECT
		         Manufacturer,
		    	 Model,
		    	 FlightHours,
		    	 Condition
			FROM Aircraft
		ORDER BY FlightHours DESC

--6

		    SELECT p.FirstName
				  ,p.LastName
				  ,a.Manufacturer
				  ,a.Model
				  ,a.FlightHours
			 FROM Pilots AS p
			 JOIN PilotsAircraft AS pa ON p.Id = pa.PilotId
			 JOIN Aircraft AS a ON pa.AircraftId = a.Id
			WHERE a.FlightHours IS NOT NULL AND a.FlightHours <= 304
		 ORDER BY a.FlightHours DESC, p.FirstName

--7
	  SELECT TOP 20
				 fd.Id AS DestinationId,
				 fd.[Start],
				 p.FullName,
				 a.AirportName,
				 fd.TicketPrice
			FROM FlightDestinations AS fd
			JOIN Passengers AS p ON fd.PassengerId = p.Id
			JOIN Airports AS a ON fd.AirportId = a.Id
		   WHERE DATEPART(day, fd.[Start]) % 2 = 0
		ORDER BY fd.TicketPrice DESC, a.AirportName

--8
			   SELECT a.id AS AircraftId
					 ,a.Manufacturer
					 ,a.FlightHours
				 	 ,COUNT(a.id) AS FlightDestinationsCount
					 ,ROUND(AVG(fd.TicketPRice),2) AS AvgPrice
		 		FROM Aircraft AS a
				JOIN FlightDestinations AS fd ON a.Id = fd.AircraftId
			GROUP BY a.Id, a.Manufacturer,a.FlightHours
			  HAVING COUNT(a.id) >= 2
			ORDER BY FlightDestinationsCount DESC, a.id

--9
			  SELECT p.FullName
					 ,COUNT(fd.AircraftId) AS CountOfAircraft
				  	 ,SUM(fd.TicketPrice) AS TotalPayed
				FROM Passengers AS p
				JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
				JOIN Aircraft AS a ON fd.AircraftId = a.Id
			   WHERE SUBSTRING(p.FullName, 2,1) = 'a'
			GROUP BY p.FullName
			  HAVING COUNT(fd.AircraftId) > 1
			ORDER BY p.FullName

--10
		   SELECT a.AirportName
				 ,fd.[Start] AS DayTime
				 ,fd.TicketPrice
				 ,p.FullName
				 ,aa.Manufacturer
				 ,aa.Model
			FROM FlightDestinations AS fd
			JOIN Airports AS a ON fd.AirportId = a.Id
			JOIN Passengers AS p ON fd.PassengerId = p.Id
			JOIN Aircraft AS aa ON fd.AircraftId = aa.Id
			WHERE DATEPART(hour, fd.[Start]) BETWEEN 6-00 AND 20-00 AND fd.TicketPrice > 2500
			ORDER BY aa.Model

--11

			CREATE OR ALTER FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(100))
				RETURNS INT
				AS
				BEGIN
					DECLARE @RESULT INT
					SET @RESULT = (SELECT COUNT(p.Id)
									 FROM Passengers AS p
									 JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
									WHERE p.Email = @email
								 GROUP BY p.Id)
					IF @RESULT IS NULL BEGIN RETURN 0 END
					RETURN @RESULT
				END

--12
		CREATE PROC usp_SearchByAirportName(@airportName VARCHAR(70))
			AS
		BEGIN
			SELECT 
					a.AirportName
				   ,p.FullName
				   ,CASE 
				   WHEN fd.TicketPrice <= 400 THEN 'Low'
				   WHEN fd.TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
				   WHEN fd.TicketPrice >= 1501 THEN 'High' 
				   END AS 'LevelOfTicketPrice'
				   ,ac.Manufacturer
				   ,ac.Condition
				   ,aty.TypeName

			  FROM Airports AS a
			JOIN FlightDestinations AS fd ON fd.AirportId = a.Id
			JOIN Passengers AS p ON fd.PassengerId = p.Id
			JOIN Aircraft AS ac ON ac.Id = fd.AircraftId
			JOIN AircraftTypes AS aty ON ac.TypeId = aty.Id
			WHERE a.AirportName = @airportName
			ORDER BY Manufacturer, p.FullName
		END
		EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'