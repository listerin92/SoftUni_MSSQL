--1
CREATE DATABASE CigarShop
GO
USE CigarShop
GO

CREATE TABLE Sizes
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Length] INT NOT NULL CHECK ([Length] BETWEEN 10 AND 25),
	RingRange DECIMAL(18,2) NOT NULL CHECK (RingRange BETWEEN 1.5 AND 7.5)
)

CREATE TABLE Tastes
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	TasteType VARCHAR(20) NOT NULL,
	TasteStrength VARCHAR(15) NOT NULL,
	ImageURL VARCHAR(100) NOT NULL
)

CREATE TABLE Brands
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	BrandName VARCHAR(30) UNIQUE NOT NULL,
	BrandDescription VARCHAR(MAX) 
)

CREATE TABLE Cigars
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CigarName VARCHAR(80) NOT NULL,
	BrandId INT FOREIGN KEY REFERENCES Brands(Id) NOT NULL,
	TastId INT FOREIGN KEY REFERENCES Tastes(Id) NOT NULL,
	SizeId INT FOREIGN KEY REFERENCES Sizes(Id) NOT NULL,
	PriceForSingleCigar MONEY NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Town VARCHAR(30) NOT NULL,
	Country NVARCHAR(30) NOT NULL,
	Streat NVARCHAR(100) NOT NULL,
	ZIP VARCHAR(20) NOT NULL
)

CREATE TABLE Clients
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
)

CREATE TABLE ClientsCigars
(
ClientId INT FOREIGN KEY REFERENCES Clients(Id) NOT NULL,
CigarId INT FOREIGN KEY REFERENCES Cigars(Id) NOT NULL,
PRIMARY KEY (ClientId, CigarId)
)

--2

INSERT INTO Cigars VALUES
('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses VALUES
('Sofia', 'Bulgaria', '18 Bul. Vasil levski', 1000),
('Athens', 'Greece', '4342 McDonald Avenue', 10435),
('Zagreb', 'Croatia', '4333 Lauren Drive', 10000)


--3
UPDATE Cigars
SET PriceForSingleCigar *= 1.2
WHERE TastId = 1

UPDATE Brands
SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

--4
DELETE FROM Clients
WHERE AddressId IN (SELECT Id FROM Addresses
WHERE Country LIKE 'C%')

DELETE FROM Addresses
WHERE Country LIKE 'C%'

--5
SELECT 
CigarName,
PriceForSingleCigar,
ImageURL
FROM Cigars
ORDER BY PriceForSingleCigar

--6
SELECT c.Id
,c.CigarName
,c.PriceForSingleCigar
,t.TasteType
,t.TasteStrength
FROM Cigars AS c
JOIN Tastes AS t ON c.TastId = t.Id
WHERE TasteType IN ('Earthy', 'Woody')
ORDER BY PriceForSingleCigar DESC

--7
SELECT cli.Id
,CONCAT(cli.FirstName, ' ', cli.LastName) AS ClientName
,cli.Email
FROM Cigars AS c
JOIN ClientsCigars AS cc ON c.Id = cc.CigarId
RIGHT JOIN Clients as cli ON cc.ClientId = cli.Id
WHERE c.Id IS NULL
ORDER BY ClientName

--8
SELECT TOP 5
	   c.CigarName
	  ,c.PriceForSingleCigar
	  ,c.ImageURL
	FROM Cigars AS c
	JOIN Sizes AS s ON c.SizeId = s.Id
	WHERE (c.CigarName LIKE '%ci%' OR c.PriceForSingleCigar > 50) 
			AND s.Length > 12 AND s.RingRange > 2.55
	ORDER BY c.CigarName, c.PriceForSingleCigar DESC

--9
SELECT 
Temp.FullName
,Temp.Country
,Temp.ZIP
, CONCAT('$', MAX(temp.CigarPrice)) AS CigarPrice
FROM 
		(SELECT 
				CONCAT(c.FirstName, ' ', c.LastName) AS [FullName]
				,a.Country
				,a.ZIP
				,cig.PriceForSingleCigar AS CigarPrice
		FROM Clients AS c
			JOIN Addresses AS a ON c.AddressId = a.Id
			JOIN ClientsCigars AS cc ON cc.ClientId = c.Id
			JOIN Cigars AS cig ON cc.CigarId = cig.Id
		WHERE a.ZIP NOT LIKE '%[A-Z]%' ) AS Temp
GROUP BY [FullName], Country, ZIP
ORDER BY FullName

--10

SELECT
cli.LastName
,AVG(s.Length) AS CiagrLength
,CEILING(AVG(s.RingRange)) AS CiagrRingRange
FROM Cigars AS c
	JOIN ClientsCigars AS cc ON c.Id = cc.CigarId
	RIGHT JOIN Clients as cli ON cc.ClientId = cli.Id
	JOIN Sizes AS s ON c.SizeId = s.Id
	WHERE c.Id IS NOT NULL
GROUP BY cli.LastName

--11
CREATE OR ALTER FUNCTION udf_ClientWithCigars(@name VARCHAR(30)) 
	RETURNS INT
	AS
		BEGIN
		DECLARE @RESULT INT
			SET @RESULT =
				(SELECT COUNT(*) FROM Clients AS c
		   JOIN ClientsCigars AS cc ON c.Id = cc.ClientId
		   JOIN Cigars AS cig ON cc.CigarId = cig.Id
				WHERE c.FirstName = @name)
		 RETURN @RESULT
		END
GO
	SELECT dbo.udf_ClientWithCigars('Betty')

--12
CREATE PROC usp_SearchByTaste(@taste VARCHAR(30))
AS
BEGIN
	SELECT 
			c.CigarName
			,CONCAT ('$', c.PriceForSingleCigar) AS Price
			,t.TasteType
			,b.BrandName
			,CONCAT(s.Length, ' cm') AS CigarLength
			,CONCAT(s.RingRange, ' cm') AS CigarRingRange
	FROM Cigars AS c
	JOIN Brands AS b ON c.BrandId = b.Id
	JOIN Tastes AS t ON c.TastId = t.Id
	JOIN Sizes AS s ON c.SizeId = s.Id
   WHERE t.TasteType = @taste
ORDER BY s.Length, s.RingRange DESC
END

EXEC usp_SearchByTaste 'Woody'