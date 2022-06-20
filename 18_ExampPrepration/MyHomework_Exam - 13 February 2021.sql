CREATE DATABASE Bitbucket
GO
USE Bitbucket
GO

CREATE TABLE Users
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors
(
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id),
	ContributorId INT FOREIGN KEY REFERENCES Users(Id),
	PRIMARY KEY (RepositoryId, ContributorId)
)

CREATE TABLE Issues
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Title VARCHAR(255) NOT NULL,
	IssueStatus VARCHAR(6) NOT NULL,
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id),
	AssigneeId INT FOREIGN KEY REFERENCES Users(Id)
)

CREATE TABLE Commits
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Message VARCHAR(255) NOT NULL,
	IssueId INT FOREIGN KEY REFERENCES Issues(Id),
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id),
	ContributorId INT FOREIGN KEY REFERENCES Users(Id),
)

CREATE TABLE Files
(
	Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	Size DECIMAL(18, 2) NOT NULL,
	ParentId INT FOREIGN KEY REFERENCES Files(Id),
	CommitId INT FOREIGN KEY REFERENCES Commits(Id)
)

--2 Exam PREP
INSERT INTO Files([Name], Size, ParentId, CommitId)
VALUES
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3,	3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)

INSERT INTO Issues(Title, IssueStatus, RepositoryId, AssigneeId)
VALUES
('Critical Problem with HomeController.cs file', 'open', 1,	4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs',	'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9,	8)

--3
UPDATE Issues
SET IssueStatus = 'closed'
WHERE AssigneeId = 6

--4

DELETE FROM RepositoriesContributors
	   WHERE RepositoryId = (SELECT Id 
							   FROM Repositories
							   WHERE [Name] = 'Softuni-Teamwork')

DELETE FROM Issues
   	  WHERE RepositoryId = (SELECT Id 
		  					  FROM Repositories
							 WHERE [Name] = 'Softuni-Teamwork')

--5
	SELECT Id, [Message], RepositoryId, ContributorId FROM Commits
	ORDER BY Id, [Message], RepositoryId, ContributorId

--6
	SELECT Id, [Name], Size FROM Files
	WHERE Size > 1000 AND [Name] LIKE '%html'
	ORDER BY Size DESC, Id, [Name]

--7
	SELECT i.Id
		  ,CONCAT(u.Username, ' : ', i.Title) AS IssueAssignee
	 FROM Issues AS i
	 JOIN Users AS u On i.AssigneeId = u.Id
 ORDER BY i.Id DESC, IssueAssignee

 --8

	 	 SELECT fp.Id
				,fp.[Name]
				,CONCAT(fp.Size,'KB') AS Size
		   FROM Files
			 AS fch
FULL OUTER JOIN Files 
			 AS fp 
			 ON fch.ParentId = fp.Id
		  WHERE fch.Id IS NULL
	   ORDER BY fp.Id, fp.Name, Size

--9	
		  SELECT TOP 5 
				 r.Id
				,r.Name
				,COUNT(c.Id) AS Commits  
			FROM Repositories AS r
	   LEFT JOIN Commits  AS c ON c.RepositoryId = r.Id
	   LEFT JOIN RepositoriesContributors  AS rc ON rc.RepositoryId = r.Id
		GROUP BY r.Id, r.Name
		ORDER BY Commits DESC, r.Id, r.Name

--10
		SELECT u.Username
			   ,AVG(f.Size) AS Size
		  FROM Commits AS c
		  JOIN Users AS u 
			ON c.ContributorId = u.Id
		  JOIN Files AS f
		    ON f.CommitId = c.Id
	  GROUP BY u.Username
	ORDER BY Size DESC, u.Username
		 

--11
CREATE OR ALTER FUNCTION udf_AllUserCommits(@username VARCHAR(30))
	RETURNS INT
	BEGIN
	DECLARE @RESULT INT
	DECLARE @userId INT = (SELECT Id FROM Users WHERE Username = @username)

	SET @RESULT = (SELECT COUNT(c.Id)
				     FROM Commits AS c
				 		WHERE c.ContributorId = @userId)
	RETURN @RESULT
	END

	SELECT dbo.udf_AllUserCommits('UnderSinduxrein')

--12
CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(10))
	AS
		BEGIN
			SELECT 
					Id
					,[Name]
					,CONCAT(Size,'KB') AS Size
			   FROM Files
			  WHERE [Name] LIKE CONCAT('%.',@fileExtension) 
		END

EXEC usp_SearchForFiles 'txt'