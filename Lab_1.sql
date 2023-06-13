--ËÀÁÎÐÀÒÎÐÍÀ ÐÎÁÎÒÀ ¹1
DROP TABLE IF EXISTS [dbo].[StructuralDepartments]
DROP TABLE IF EXISTS [dbo].[Positions]
DROP TABLE IF EXISTS [dbo].[Employees]
DROP TABLE IF EXISTS [dbo].[HourlyRates]
DROP TABLE IF EXISTS [dbo].[WorkTime]
DROP TABLE IF EXISTS [dbo].[Vacations]
DROP TABLE IF EXISTS [dbo].[SalaryPayments]
GO

CREATE TABLE [dbo].[StructuralDepartments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	DepartmentName NVARCHAR(50) NOT NULL,
	DepartmentManager NVARCHAR(50) NOT NULL
 CONSTRAINT [PK_StructuralDepartments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Employees](
	[id] [int] IDENTITY(1,1) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NOT NULL,
    PassportData NVARCHAR(50) NOT NULL,
    DateOfBirth DATETIME NOT NULL,
    PlaceOfBirth NVARCHAR(50) NOT NULL,
    HomeAddress NVARCHAR(100) NOT NULL,
    Department_id INT NOT NULL,
    Position_id INT NOT NULL	
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Positions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	PositionName NVARCHAR(50) NOT NULL	
 CONSTRAINT [PK_Positions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[HourlyRates](
	[id] [int] IDENTITY(1,1) NOT NULL,
	Position_id INT NOT NULL,
	HourlyRate DECIMAL(10, 2) NOT NULL
 CONSTRAINT [PK_HourlyRates] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[WorkTime](
	[id] [int] IDENTITY(1,1) NOT NULL,
	Employee_id INT NOT NULL,
    WorkDate DATETIME NOT NULL,
    WorkHours INT NOT NULL
 CONSTRAINT [PK_WorkTime] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Vacations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	Employee_id INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    Duration INT NOT NULL,
    WorkedDaysLast12Months INT NOT NULL
 CONSTRAINT [PK_Vacations] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[SalaryPayments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	Employee_id INT NOT NULL,
    MonthYear DATETIME NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Deductions DECIMAL(10, 2) NOT NULL,
    NetSalary DECIMAL(10, 2) NOT NULL	
 CONSTRAINT [PK_SalaryPayments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Vacations]
ADD CONSTRAINT CHK_Duration
CHECK (Duration >= 0);
ALTER TABLE [dbo].[Vacations] WITH CHECK ADD CONSTRAINT [FK_Vacations_Employees] FOREIGN KEY ([Employee_id]) 
REFERENCES [Employees]([id])
ON DELETE NO ACTION
GO
ALTER TABLE [dbo].[SalaryPayments] WITH CHECK ADD CONSTRAINT [FK_SalaryPayments_Employees] FOREIGN KEY([Employee_id])
REFERENCES [dbo].[Employees] ([id])
ON DELETE NO ACTION
GO
ALTER TABLE [dbo].[WorkTime] WITH CHECK ADD CONSTRAINT [FK_WorkTime_Employees] FOREIGN KEY([Employee_id])
REFERENCES [dbo].[Employees] ([id])
ON DELETE NO ACTION
GO
ALTER TABLE [dbo].[HourlyRates] WITH CHECK ADD CONSTRAINT [FK_HourlyRates_Positions] FOREIGN KEY([Position_id])
REFERENCES [dbo].[Positions] ([id])
ON DELETE NO ACTION
GO
ALTER TABLE [dbo].[Employees] WITH CHECK ADD CONSTRAINT [FK_Employees_StructuralDepartments] FOREIGN KEY([Department_id])
REFERENCES [dbo].[StructuralDepartments] ([id])
ON DELETE NO ACTION
GO
ALTER TABLE [dbo].[Employees] WITH CHECK ADD CONSTRAINT [FK_Employees_Positions] FOREIGN KEY([Position_id])
REFERENCES [dbo].[Positions] ([id])
ON DELETE NO ACTION
GO

DELETE FROM [dbo].[StructuralDepartments]
DELETE FROM [dbo].[Positions]
DELETE FROM [dbo].[Employees]
DELETE FROM [dbo].[HourlyRates]
DELETE FROM [dbo].[WorkTime]
DELETE FROM [dbo].[Vacations]
DELETE FROM [dbo].[SalaryPayments]
GO

INSERT INTO [dbo].[StructuralDepartments]
	([DepartmentName], [DepartmentManager])
VALUES
	 ( 'StatisticsDepartment', 'Wilson'),
	 ('IndustrialDepartment','Smith');
INSERT INTO [dbo].[Positions]
	([PositionName])
VALUES
	('Main Engineer'),
	('Accountant');
INSERT INTO [dbo].[Employees]
	([LastName], [FirstName], [MiddleName], [PassportData], [DateOfBirth], [PlaceOfBirth], [HomeAddress],[Position_id],[Department_id])
VALUES
	('Nickolson','David','Woodbury','938472935','1989-04-25','Kansas City, USA','9249 Union St.Brooklyn, NY 11224',1,1),
	('MacFarland','Ann','Egan','563837481','1994-10-17','Glasgow, United Kingdom','70 East Holly Rd. New York, NY 10003',2,2);
INSERT INTO [dbo].[HourlyRates]
	([Position_id],[HourlyRate])
VALUES
	(2,'10'),
	(1,'11');
INSERT INTO [dbo].[WorkTime]
	([WorkDate],[Employee_id],[WorkHours])
VALUES('2023-05-26',1,'8'),
      ('2023-05-27',2,'8');
INSERT INTO [dbo].[Vacations]
	([Employee_id],[StartDate], [EndDate], [Duration], [WorkedDaysLast12Months])
VALUES(1,'2023-06-05','2023-06-18','14','243'),
      (2,'2023-08-21','2023-09-10','21','246');
INSERT INTO [dbo].[SalaryPayments]
	([Employee_id],[MonthYear], [Salary], [Deductions], [NetSalary])
VALUES(1,'2023-06-10','2640','528','2112'),
      (2,'2023-06-10','2540','508','2032');