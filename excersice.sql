--1 wa
CREATE DATABASE [Minions]
USE Minions


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
('asdf1', '12343', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:35', 0),
('asdf2', '12344', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:36', 0),
('asdf3', '12345', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:37', 1),
('asdf4', '12346', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:38', 1),
('asdf5', '12347', 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png', '2021-01-13 15:39', 1)

--9ta

ALTER TABLE Users DROP CONSTRAINT PK__Users__3214EC0793D7249B
ALTER TABLE Users 
ADD CONSTRAINT PK_Users PRIMARY KEY (Id,Username);