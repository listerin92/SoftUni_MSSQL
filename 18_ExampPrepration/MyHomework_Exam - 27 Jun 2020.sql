CREATE DATABASE WMS
GO
USE WMS
GO

--1
CREATE TABLE Clients
(
	ClientId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Phone VARCHAR(12) CHECK (LEN(Phone) = 12)
)

CREATE TABLE Mechanics
(
	MechanicId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,	
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,
)

CREATE TABLE Models
(
	ModelId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) UNIQUE NOT NULL,
)

CREATE TABLE Jobs
(
	JobId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ModelId INT FOREIGN KEY REFERENCES Models(ModelId) NOT NULL,
	[Status] VARCHAR(11) 
	CHECK ([Status] = 'Pending' OR [Status] = 'In Progress' OR [Status] = 'Finished') DEFAULT 'Pending' NOT NULL,
	ClientId INT FOREIGN KEY REFERENCES Clients(ClientId) NOT NULL,
	MechanicId INT FOREIGN KEY REFERENCES Mechanics(MechanicId),
	IssueDate DATE NOT NULL,
	FinishDate DATE
)

CREATE TABLE Orders
(
	OrderId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	JobId INT FOREIGN KEY REFERENCES Jobs(JobId) NOT NULL,
	IssueDate DATE,
	Delivered BIT DEFAULT 0 NOT NULL
)

CREATE TABLE Vendors
(
	VendorId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) UNIQUE NOT NULL,
)

CREATE TABLE Parts
(
	PartId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	SerialNumber VARCHAR(50) UNIQUE NOT NULL,
	[Description] VARCHAR(255),
	Price MONEY CHECK(Price !=0 OR PRICE > 0) NOT NULL,
	VendorId INT FOREIGN KEY REFERENCES Vendors(VendorId) NOT NULL,
	StockQty INT CHECK(StockQty >= 0) DEFAULT 0 NOT NULL
)

CREATE TABLE OrderParts
(
	OrderId INT FOREIGN KEY REFERENCES Orders(OrderId) NOT NULL,
	PartId INT FOREIGN KEY REFERENCES Parts(PartId) NOT NULL,
	Quantity INT CHECK (Quantity > 0) DEFAULT 1 NOT NULL,
	PRIMARY KEY (OrderId, PartId)
)

CREATE TABLE PartsNeeded
(
	JobId INT FOREIGN KEY REFERENCES Jobs(JobId) NOT NULL,
	PartId INT FOREIGN KEY REFERENCES Parts(PartId) NOT NULL,
	Quantity INT CHECK (Quantity > 0) DEFAULT 1 NOT NULL,
	PRIMARY KEY (JobId, PartId)
)

--2

INSERT INTO Clients(FirstName, LastName, Phone)
VALUES
('Teri','Ennaco', '570-889-5187'),
('Merlyn','Lawler', '201-588-7810'),
('Georgene', 'Montezuma', '925-615-5185'),
('Jettie', 'Mconnell', '908-802-3564'),
('Lemuel', 'Latzke', '631-748-6479'),
('Melodie', 'Knipp', '805-690-1682'),
('Candida', 'Corbley', '908-275-8357')

INSERT INTO Parts( SerialNumber, [Description], Price, VendorId)
VALUES
('WP8182119', 'Door Boot Seal', 117.86, 2),
('W10780048','Suspension Rod', 42.81, 1),
('W10841140', 'Silicone Adhesive', 6.77, 4),
('WPY055980', 'High Temperature Adhesive', 13.94, 3)

--3
UPDATE Jobs
SET MechanicId = 3,
	Status = 'In Progress'
WHERE Status = 'Pending'

--4
DELETE From OrderParts
WHERE OrderId = 19
DELETE FROM Orders
WHERE OrderId = 19

--5
	SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic
		   ,j.[Status]
		   ,j.IssueDate
	  FROM JOBS AS j
	  JOIN Mechanics 
		AS m 
		ON j.MechanicId = m.MechanicId
  ORDER BY m.MechanicId, j.IssueDate, j.JobId

--6
	SELECT CONCAT(c.FirstName, ' ', c.LastName) AS Client,
		   DATEDIFF(day, j.IssueDate, '2017-04-24') AS 'Days going',
		   j.[Status]
	  FROM Jobs 
	    AS j
	  JOIN Clients 
	    AS c 
		ON j.ClientId = c.ClientId
	 WHERE j.[Status] != 'Finished'
  ORDER BY [Days going] DESC, c.ClientId

--7

SELECT temp.Mechanic,
		AVG(temp.DaysFinished) AS 'Average Days'
	FROM
		(
			SELECT m.MechanicId,
				   CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic,
				   DATEDIFF(day, j.IssueDate, j.FinishDate) as DaysFinished
			  FROM Mechanics AS m
			  JOIN Jobs 
				AS j 
				ON m.MechanicId = j.MechanicId
		) AS temp
	GROUP BY temp.Mechanic, temp.MechanicId
	ORDER BY temp.MechanicId

--8
	   SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Available]
	 	 FROM Mechanics AS m
	LEFT JOIN Jobs AS j ON m.MechanicId = j.MechanicId
	    WHERE m.MechanicId NOT IN (SELECT MechanicId 
									 FROM Jobs
							  	    WHERE [Status] = 'In Progress')
	 GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId
	 ORDER BY m.MechanicId
	 --select all without this not in progress, маха от 2рия селект тези които са били в първия.(заетите)


--9
	SELECT j.JobId
		   , ISNULL(SUM(p.Price * op.Quantity),0) AS [Total] 
	  FROM Jobs AS j
	  LEFT JOIN Orders AS o ON j.JobId = o.JobId
	  LEFT JOIN OrderParts AS op ON o.OrderId = op.OrderId
	  LEFT JOIN Parts AS p ON op.PartId = p.PartId
	 WHERE [Status] = 'Finished'
  GROUP BY j.JobId
  ORDER BY Total DESC, j.JobId


--10
SELECT * FROM
(		SELECT p.PartId
			   ,p.[Description]
			   ,pn.Quantity AS [Required]
			   ,p.StockQty AS [In Stock]
			   ,ISNULL(op.Quantity,0) AS [Ordered]
			   
	  FROM Jobs AS j
	  LEFT JOIN PartsNeeded AS pn ON pn.JobId = j.JobId
	  LEFT JOIN Parts AS p ON p.PartId = pn.PartId
	  LEFT JOIN Orders AS o ON j.JobId = o.JobId
	  LEFT JOIN OrderParts AS op ON op.OrderId = o.OrderId
	 WHERE j.[Status] <> 'Finished' AND (o.Delivered = 0 OR o.Delivered IS NULL)) AS temp
	 WHERE temp.[In Stock] + temp.Ordered < temp.[Required]
	 ORDER BY temp.PartId

SELECT * FROM 
(SELECT p.PartId
, p.[Description]
, pn.Quantity AS [Required]
, p.StockQty AS [In Stock]
, ISNULL(op.Quantity,0) AS [Ordered]
FROM Jobs AS j
LEFT JOIN PartsNeeded AS pn ON j.JobId = pn.JobId
LEFT JOIN Parts AS p ON pn.PartId = p.PartId
LEFT JOIN Orders AS o ON j.JobId = o.JobId
LEFT JOIN OrderParts AS op ON o.OrderId = op.OrderId
WHERE j.[Status] <> 'Finished' AND (o.Delivered = 0 OR o.Delivered IS NULL)
) AS temp
WHERE temp.[In Stock] + temp.Ordered < temp.[Required]
ORDER BY temp.PartId