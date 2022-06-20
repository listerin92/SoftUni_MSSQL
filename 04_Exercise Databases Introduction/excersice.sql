--1 wa
CREATE DATABASE [Minions]
USE Minions
GO

--2ra
CREATE TABLE Minions 
(
Id int NOT NULL PRIMARY KEY, 
Name NVARCHAR(50) NOT NULL,
Age INT
)

CREATE TABLE Towns 
(Id int NOT NULL PRIMARY KEY, 
Name NVARCHAR(70) NOT NULL
)
--3ta

ALTER TABLE Minions
ADD TownId INT NOT NULL

ALTER TABLE Minions
ADD CONSTRAINT FK_TownId
FOREIGN KEY (TownId) REFERENCES Towns(Id)

--4ta
INSERT INTO Towns ([Id], [Name])
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions ([Id], [Name], [Age], [TownId])
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

--7ma

/*
•	Id – unique number. For every person there will be no more than 231-1 people. (Auto incremented)
•	Name – full name of the person. There will be no more than 200 Unicode characters. (Not null)
•	Picture – image with size up to 2 MB. (Allow nulls)
•	Height – in meters. Real number precise up to 2 digits after floating point. (Allow nulls)
•	Weight – in kilograms. Real number precise up to 2 digits after floating point. (Allow nulls)
•	Gender – possible states are m or f. (Not null)
•	Birthdate – (Not null)
•	Biography – detailed biography of the person. It can contain max allowed Unicode characters. (Allow nulls)
Make the Id a primary key. Populate the table with only 5 records. Submit your CREATE and INSERT statements as Run queries & check DB.


*/
CREATE TABLE People
(
Id int IDENTITY(1,1) PRIMARY KEY NOT NULL , 
Name VARCHAR(200) NOT NULL,
Picture VARBINARY(2048),
Height NUMERIC(5,2),
Weight NUMERIC(5,2),
Gender Char(1) NOT NULL,
Birthdate DATE NOT NULL,
Biography VARCHAR(MAX)
)

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES
('Ivan1', NULL, 1.75, 75.25, 'm', '1978-01-01', 'asdf'),
('Ivan2', NULL, 1.76, 75.35, 'm', '1978-03-05', 'asdfa sfasdfa'),
('Ivan3', NULL, 1.77, 75.45, 'f', '1978-02-06', 'asdf fdas'),
('Ivan4', NULL, 1.78, 75.55, 'f', '1978-01-02', 'asdfa asdfasda'),
('Ivan5', NULL, 1.79, 75.65, 'f', '1978-01-03', 'asdf asdfasdf')


-- 8ma

CREATE TABLE Users
(
Id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
Username VARCHAR(30) NOT NULL,
[Password] VARCHAR(26) NOT NULL,
ProfilePicture VARCHAR(max),
LastLoginTime DATETIME2,
IsDeleted BIT
);

INSERT INTO Users(Username, [Password], ProfilePicture, LastLoginTime, IsDeleted)
VALUES
('asdf1', '123456', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:35', 0),
('asdf2', '123446', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:36', 0),
('asdf3', '123456', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:37', 1),
('asdf4', '123466', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:38', 1),
('asdf5', '123476', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:39', 1)

--9ta

ALTER TABLE Users DROP CONSTRAINT PK__Users__3214EC077AC3D108
ALTER TABLE Users 
ADD CONSTRAINT PK_Users PRIMARY KEY (Id,Username);

--10ta

ALTER TABLE Users ADD CONSTRAINT CH_PasswordIsAtLeast5Symbols CHECK (LEN([Password]) > 5)

--11ta

--ALTER TABLE Users
--ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime

UPDATE Users
SET LastLoginTime = GETDATE()

--12ta
ALTER TABLE Users DROP CONSTRAINT PK_Users
ALTER TABLE Users
ADD CONSTRAINT PK_ID PRIMARY KEY (Id)
ALTER TABLE Users
ADD CONSTRAINT CH_UserName CHECK (LEN(Username) > 3)

--13ta Movies Database
CREATE DATABASE Movies
GO
USE Movies
CREATE TABLE Directors
(
	Id int NOT NULL IDENTITY PRIMARY KEY, 
	DirectorName VARCHAR(200),
	Notes VARCHAR(250),
)
CREATE TABLE Genres
(
	Id int NOT NULL IDENTITY PRIMARY KEY, 
	GenreName VARCHAR(200),
	Notes VARCHAR(250),
)
CREATE TABLE Categories
(
	Id int NOT NULL IDENTITY PRIMARY KEY, 
	CategoryName VARCHAR(200),
	Notes VARCHAR(250),
)
CREATE TABLE Movies
(
	Id int NOT NULL IDENTITY PRIMARY KEY, 
	Title VARCHAR(200),
	DirectorId int NOT NULL,
	CopyrightYear DATETIME,
	[Length] int NOT NULL,
	GenreId int NOT NULL,
	CategoryId int NOT NULL,
	Rating int,
	Notes VARCHAR(250)
)
ALTER TABLE Movies
ADD CONSTRAINT FK_GenreId
FOREIGN KEY (GenreId) REFERENCES Genres(Id)

ALTER TABLE Movies
ADD CONSTRAINT FK_CategoryId
FOREIGN KEY (CategoryId) REFERENCES Categories(Id)

ALTER TABLE Movies
ADD CONSTRAINT FK_DirectorId
FOREIGN KEY (DirectorId) REFERENCES Directors(Id)

INSERT INTO Directors 
VALUES
('David Linch', 'Best'),
('Francis Ford Coppola', 'Best1'),
('Christopher Nolan', 'Best2'),
('Christopher Nolan2', 'Best2'),
('Christopher Nolan3', 'Best2')

INSERT INTO Genres 
VALUES
('Drama', 'Best1'),
('Horror', 'Best2'),
('Sci-Fi', 'Best3'),
('Comedy', 'Best4'),
('Action', 'Best5')

INSERT INTO Categories 
VALUES
('12+', 'Best1'),
('16+', 'Best2'),
('18+', 'Best3'),
('Adult', 'Best4'),
('No Limit', 'Best5')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes) 
VALUES
('Shaushenk Redemption', 2, 1998, 180, 1, 2, 5,'asdf'),
('Shaushenk Redemption', 1, 1990, 180, 2, 2, 3,'asdf'),
('Shaushenk Redemption', 3, 1920, 120, 3, 3, 4,'asdf'),
('Shaushenk Redemption', 4, 1938, 160, 4, 4, 5,'asdf'),
('Shaushenk Redemption', 5, 1958, 140, 5, 5, 5,'asdf')




--14ta Car Rental Database
CREATE DATABASE CarRental
GO
USE CarRental

CREATE TABLE Categories
(
	Id int NOT NULL IDENTITY PRIMARY KEY
	,CategoryName NVARCHAR(200)
	,DailyRate INT
	,WeeklyRate INT
	,MonthlyRate INT
	,WeekendRate INT
)

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
('BUS',100,90,80,120)
,('CAR',101,91,81,121)
,('CAMPER',102,92,82,122)

CREATE TABLE Cars
(
	Id INT NOT NULL IDENTITY PRIMARY KEY
	,PlateNumber NVARCHAR(200)
	,Manufacturer NVARCHAR(200)
	,Model NVARCHAR(200)
	,CarYear INT
	,CategoryId INT
	,Doors INT
	,Picture VARCHAR(MAX)
	,Condition NVARCHAR(200)
	,Available bit	
)

ALTER TABLE Cars
ADD CONSTRAINT FK_CategoryId
FOREIGN KEY (CategoryId) REFERENCES Categories(Id)

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
VALUES
(N'ÑÀ2312', 'HONDA', 'CIVIC', 2006, 2, 4,'https://cdn.business2community.com/blank-profile.png', 'Damaged', 1)
,(N'ÑÀ2313', 'VW', 'GOLF', 2008, 1, 5,'https://cdn.business2community.com/blank-profile.png', 'USED', 1)
,(N'ÑÀ2314', 'FIAT', 'CAMPUS', 2016, 3, 2,'https://cdn.business2community.com/blank-profile.png', 'New', 1)

CREATE TABLE Employees
(
	Id INT NOT NULL IDENTITY PRIMARY KEY
	,FirstName NVARCHAR(200)
	,LastName NVARCHAR(200)
	,Title NVARCHAR(200)
	,Notes NVARCHAR(MAX)
)
INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES
('IVAN', 'Petrov', 'Manager', 'ASDASDdsasdasda')
,('Stefan', 'Todorov', 'Sales', 'ASDASDdsasdasda')
,('Georgi', 'Ivanov', 'Mechanic', 'ASDASDdsasdasda')

CREATE TABLE Customers
(
	Id INT NOT NULL IDENTITY PRIMARY KEY
	,DriverLicenceNumber NVARCHAR(200)
	,FullName NVARCHAR(200)
	,[Address] NVARCHAR(200)
	,City NVARCHAR(200)
	,ZIPCode SMALLINT
	,Notes NVARCHAR(MAX)
)
INSERT INTO Customers (DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes)
VALUES
(N'sa21341', 'Stefan PEtrov', '7 Dondukov', 'Sofia', 1111, 'asdfasdf')
,(N'sa21342', 'Stefan PEtrov', '71 Dondukov', 'Varna', 1221, 'asdfasdf')
,(N'sa21343', 'Stefan PEtrov', '52 Dondukov', 'Sofia', 1331, 'asdfasdf')


CREATE TABLE RentalOrders
(
	Id INT NOT NULL IDENTITY PRIMARY KEY
	,EmployeeId INT
	,CustomerId INT
	,CarId INT
	,TankLevel INT NOT NULL
	,KilometrageStart INT NOT NULL
	,KilometrageEnd INT NOT NULL
	,TotalKilometrage INT NOT NULL
	,StartDate DATETIME2
	,EndDate DATETIME2
	,TotalDays SMALLINT
	,RateApplied SMALLINT
	,TaxRate SMALLINT
	,OrderStatus SMALLINT
	,Notes NVARCHAR(MAX)
)

ALTER TABLE RentalOrders
ADD CONSTRAINT FK_EmployeeId
FOREIGN KEY (EmployeeId) REFERENCES Employees(Id)

ALTER TABLE RentalOrders
ADD CONSTRAINT FK_CustomerId
FOREIGN KEY (CustomerId) REFERENCES Customers(Id)

ALTER TABLE RentalOrders
ADD CONSTRAINT FK_CarId
FOREIGN KEY (CarId) REFERENCES Cars(Id)

INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, 
KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, 
TaxRate, OrderStatus, Notes)
VALUES
(1, 2, 3, 20, 1000, 2000, 1000, '2022-05-20', '2022-05-22', 2, 1,2, 3,'asdf')
,(1, 2, 3, 20, 1000, 2000, 1000, '2022-05-20', '2022-05-22', 2, 1,2, 2,'asdf')
,(1, 2, 3, 20, 1000, 2000, 1000, '2022-05-20', '2022-05-22', 2, 1,2, 1,'asdf')

--15ta Hotel Database

CREATE DATABASE Hotel 
GO
USE Hotel 

CREATE TABLE Employees
(
	Id INT NOT NULL IDENTITY PRIMARY KEY
	,FirstName NVARCHAR(200)
	,LastName NVARCHAR(200)
	,Title NVARCHAR(200)
	,Notes NVARCHAR(MAX)
)

INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES
('Ivan', 'Ivanov', 'Manager', 'dadada')
,('Stefan', 'Todorov', 'Sales', 'dadada')
,('Petar', 'Petrov', 'Support', 'dadada')


CREATE TABLE Customers
(
	AccountNumber INT
	,DriverLicenceNumber NVARCHAR(200)
	,FirstName NVARCHAR(200)
	,LastName NVARCHAR(200)
	,PhoneNumber INT
	,EmergencyName NVARCHAR(200)
	,EmergencyNumber INT
	,Notes NVARCHAR(MAX)
)

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, 
EmergencyNumber, Notes)
VALUES
(21123,'Ivan', 'Petrov', 123123123, 'vankata', 321321321, 'dada')
,(21123,'Ivan', 'Petrov', 123123123, 'vankata', 321321321, 'dada')
,(21123,'Ivan', 'Petrov', 123123123, 'vankata', 321321321, 'dada')


CREATE TABLE RoomStatus 
(
	RoomStatus NVARCHAR(200)
	,Notes NVARCHAR(MAX)
)
INSERT INTO RoomStatus (RoomStatus, Notes)
VALUES
('Busy', 'asdffdsa' )
,('Free', 'asdffdsa' )
,('For Repair', 'asdffdsa' )

CREATE TABLE RoomTypes 
(
	RoomType NVARCHAR(MAX)
	, Notes NVARCHAR(MAX)
)

INSERT INTO RoomTypes (RoomType, Notes)
VALUES
('2 beds', 'asdf' )
,('appartment', 'asdf' )
,('see view', 'asdf' )

CREATE TABLE BedTypes 
(BedType NVARCHAR(MAX)
, Notes NVARCHAR(MAX)
)

INSERT INTO BedTypes (BedType, Notes)
VALUES
('single bed', 'asdf')
,('twin bed', 'asdf')
,('sofa bed', 'asdf')

CREATE TABLE Rooms 
(
RoomNumber INT
, RoomType INT
, BedType INT
, Rate MONEY
, RoomStatus NVARCHAR(MAX)
, Notes NVARCHAR(MAX)
)

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
VALUES
(123, 1, 2,  123.12, 'asas', 'asdf' )
,(123, 1, 2,  123.12, 'asas', 'asdf' )
,(123, 1, 2,  123.12, 'asas', 'asdf' )

CREATE TABLE Payments
(
Id INT NOT NULL IDENTITY PRIMARY KEY
, EmployeeId INT
, PaymentDate DATETIME2
, AccountNumber INT
, FirstDateOccupied DATETIME2
, LastDateOccupied DATETIME2
, TotalDays SMALLINT
, AmountCharged MONEY
, TaxRate INT
, TaxAmount MONEY
, PaymentTotal MONEY
, Notes NVARCHAR(MAX)
)

ALTER TABLE Payments
ADD CONSTRAINT FK_EmployeeId
FOREIGN KEY (EmployeeId) REFERENCES Employees(Id)

INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, 
FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes)
VALUES
(1, '2022-07-01', 123, '2022-07-01', '2022-07-01', 3, 123.32, 20, 123.1, 444.32, 'asdf')
,(2, '2022-07-01', 123, '2022-07-01', '2022-07-01', 3, 123.32, 20, 123.1, 444.32, 'asdf')
,(3, '2022-07-01', 123, '2022-07-01', '2022-07-01', 3, 123.32, 20, 123.1, 444.32, 'asdf')

CREATE TABLE Occupancies 
(
Id INT NOT NULL IDENTITY PRIMARY KEY
, EmployeeId INT
, DateOccupied DATETIME2
, AccountNumber INT
, RoomNumber INT
, RateApplied MONEY
, PhoneCharge MONEY
, Notes NVARCHAR(MAX)
)
ALTER TABLE Occupancies
ADD CONSTRAINT FK_Occupancies_EmployeeId
FOREIGN KEY (EmployeeId) REFERENCES Employees(Id)

INSERT INTO Occupancies (EmployeeId, DateOccupied, AccountNumber, 
RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES
(1, '2022-07-01', 312321, 123, 320.1, 123.32, 'asdf')
,(2, '2022-07-01', 312321, 123, 320.1, 123.32, 'asdf')
,(2, '2022-07-01', 312321, 123, 320.1, 123.32, 'asdf')

--18 Basic Insert
USE SoftUni
INSERT INTO Towns ([Name])
VALUES
('Sofia')
,('Plovdiv')
,('Varna')
,('Burgas')

INSERT INTO Departments([Name])
VALUES
('Engineering')
,('Sales')
,(' Marketing')
,('Software Development') 
,('Quality Assurance') 


--19ta
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--20ta
SELECT * FROM Towns ORDER BY Name Asc
SELECT * FROM Departments ORDER BY Name Asc
SELECT * FROM Employees ORDER BY Salary Desc

--21ta

SELECT [Name] FROM Towns ORDER BY Name Asc
SELECT [Name] FROM Departments ORDER BY Name Asc
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary Desc

--22ra
UPDATE Employees
SET Salary  *= 1.1
Select Salary FROM Employees

--23ta
USE Hotel
UPDATE Payments
SET TaxRate = TaxRate - (0.03 * TaxRate)
SELECT TaxRate FROM Payments


--24ta

TRUNCATE TABLE Occupancies