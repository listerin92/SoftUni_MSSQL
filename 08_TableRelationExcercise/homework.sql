--------- 1va One To One
CREATE TABLE Persons(
	PersonID INT IDENTITY(1,1) NOT NULL
	,FirstName NVARCHAR(200)
	,Salary MONEY
	,PassportID INT UNIQUE
)

ALTER TABLE Persons
 ADD CONSTRAINT PK_PersonID  PRIMARY KEY (PersonID) 

CREATE TABLE Passports(
	PassportID INT IDENTITY (101,1) PRIMARY KEY
	,PassportNumber NVARCHAR(8)
)

ALTER TABLE Persons
	ADD CONSTRAINT FK_Passports_Persons FOREIGN KEY
	(PassportID) REFERENCES Passports(PassportID)

INSERT INTO Passports (PassportNumber)
VALUES
	('N34FG21B')
	,('K65LO4R7')
	,('ZE657QP2')

INSERT INTO Persons (FirstName, Salary, PassportID)
VALUES
('Roberto', 43300, 102)
,('Tom', 56100, 103)
,('Yana', 60200, 101)

INSERT INTO Persons (FirstName, Salary, PassportID)
VALUES
('Tom', 13300, 102) -- not possible to insert same PassportID because of UNIQUE constraint


--2 ra One To Many
CREATE TABLE Manufacturers(
ManufacturerID INT IDENTITY (1,1) PRIMARY KEY NOT NULL
, Name NVARCHAR(30)
,EstablishedOn DATE
)
CREATE TABLE Models(
	ModelID INT IDENTITY (101,1) PRIMARY KEY NOT NULL
	,Name NVARCHAR(30) 
	,ManufacturerID INT FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers ([Name], EstablishedOn)
VALUES
('BMW', '07/03/1916')
,('Tesla', '01/01/2003')
,('Lada', '01/05/1966')

INSERT INTO Models([Name], ManufacturerID)
VALUES
('X1',1)
,('i6', 1)
,('Model S', 2)
,('Model X', 2)
,('Model 3', 2)
,('Nova', 3)

--3ta Many To Many

CREATE TABLE Students(
StudentID INT IDENTITY (1,1) PRIMARY KEY
,[Name] NVARCHAR(30)
)

INSERT INTO Students([Name])
VALUES
('Mila')
,('Toni')
,('Ron')

CREATE TABLE Exams(
ExamID INT IDENTITY (101,1) PRIMARY KEY
,[Name] NVARCHAR(30)
)

INSERT INTO Exams([Name])
VALUES
('SpringMVC')
,('Neo4j')
,('Oracle 11g')

CREATE TABLE StudentsExams(
StudentID INT FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
, ExamID INT FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
PRIMARY KEY(StudentID, ExamID)
)

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES
(1, 101)
,(1, 102)
,(2, 101)
,(3, 103)
,(2, 102)
,(2, 103)

-- 4ta Self-Referencing

CREATE TABLE Teachers(
TeacherID INT IDENTITY (101,1) PRIMARY KEY NOT NULL
,[Name] NVARCHAR(30) NOT NULL
,ManagerID INT FOREIGN KEY (ManagerID) REFERENCES  Teachers(TeacherID)
)

INSERT INTO Teachers([Name], ManagerID)
VALUES
('John', NULL)
,('Maya', 106)
,('Silvia', 106)
,('Ted', 105)
,('Mark', 101)
,('Greta', 101)

--5ta OnlineStore from DataDiagram

CREATE DATABASE OnlineStore
GO
USE OnlineStore
GO
CREATE TABLE Cities(
CityID INT IDENTITY PRIMARY KEY NOT NULL
,[Name] VARCHAR(50)
)
CREATE TABLE Customers(
CustomerID INT IDENTITY PRIMARY KEY NOT NULL
,[Name] VARCHAR(50)
,Birthday DATE
,CityID INT FOREIGN KEY (CityID) REFERENCES Cities(CityID)
)
CREATE TABLE Orders(
OrderID INT IDENTITY PRIMARY KEY NOT NULL
,CustomerID INT FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes(
ItemTypeID INT IDENTITY PRIMARY KEY NOT NULL
,[Name] VARCHAR(50)
)

CREATE TABLE Items(
ItemID INT IDENTITY PRIMARY KEY NOT NULL
,[Name] VARCHAR(50)
,ItemTypeID INT FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID )
)

CREATE TABLE OrderItems(
OrderID INT FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
,ItemID INT FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
PRIMARY KEY (OrderID, ItemID)
)

--6ta University DB from DATA Diagram
CREATE DATABASE University
GO
USE University
GO

CREATE TABLE Subjects(
SubjectID INT IDENTITY PRIMARY KEY NOT NULL
,SubjectName VARCHAR(50)
)
CREATE TABLE Majors(
MajorID INT IDENTITY PRIMARY KEY NOT NULL
,[Name] VARCHAR(50)
)

CREATE TABLE Students(
StudentID INT IDENTITY PRIMARY KEY NOT NULL
,StudentNumber INT
,StudentName VARCHAR(50)
,MajorID INT FOREIGN KEY (MajorID) REFERENCES Majors(MajorID)
)
CREATE TABLE Payments(
PaymentID INT IDENTITY PRIMARY KEY NOT NULL
,PaymentDate DATE
,PaymentAmount MONEY
,StudentID INT FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
)

CREATE TABLE Agenda(
StudentID INT FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
,SubjectID INT FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
PRIMARY KEY (StudentID, SubjectID)
)

--9ta Peaks In Rila
SELECT m.MountainRange, p.PeakName, p.Elevation FROM Peaks as p
JOIN Mountains as m ON p.MountainId = m.Id
WHERE MountainID = 17
ORDER BY Elevation DESC