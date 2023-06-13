--����������� ������ �2
--1.SELECT �� ��� ���� ������� � ������������� ����������, ����������� ���� � ��������
--AND
SELECT * FROM [StructuralDepartments] S
WHERE S.DepartmentManager='Wilson' AND S.DepartmentName='StatisticsDepartment'
GO
--OR
SELECT * FROM [StructuralDepartments] S
WHERE S.DepartmentManager='Smith' OR S.DepartmentName='StatisticsDepartment'
GO

--2.SELECT � ������� ������������ ���� (������) � �������� ����������
SELECT E.Position_id AS 'Position' , COUNT(*) AS 'AMOUNT OF Position' FROM [Employees] E
GROUP BY E.Position_id 
GO

--3.SELECT �� ��� ������ ������� � ������������� ����������, ����������� ���� � ��������
--AND
SELECT *FROM [Employees] E
LEFT JOIN [Vacations] V ON V.Employee_id=E.id 
WHERE E.FirstName='David' AND V.StartDate='2023-06-18'
GO
--OR
SELECT *FROM [Employees] E 
LEFT JOIN [Vacations] V  ON V.Employee_id=E.id
WHERE E.FirstName='David' OR V.StartDate='2023-10-17 09:00:00'
GO

--4.SELECT �� ��� ������ ������� � ����� �������� Outer Join
SELECT E.DateOfBirth, V.WorkedDaysLast12Months
FROM [Vacations] V
FULL OUTER JOIN [Employees] E ON V.Employee_id = E.id
GO

--5.SELECT � ������������� ��������� Like, Between, In, Exists, All, Any
--LIKE
SELECT *FROM [StructuralDepartments] S
WHERE S.DepartmentManager LIKE 'W%'
GO
--BETWEEN
SELECT *FROM [WorkTime] WT
WHERE WT.WorkDate BETWEEN '2023-10-17 09:00:00' AND '2023-10-17 12:00:00'
GO
--IN
SELECT *
FROM [StructuralDepartments] S WHERE S.DepartmentManager IN ('Smith','Wilson')
GO
--EXISTS
SELECT *FROM [Employees] E
WHERE EXISTS(
 SELECT * FROM [StructuralDepartments] S
 WHERE S.DepartmentManager LIKE '%Smith%' AND  S.id=E.Department_id)
GO
--ALL
SELECT *FROM [Employees] E
WHERE E.Department_id != ALL(
 SELECT S.id FROM [StructuralDepartments] S
 WHERE S.DepartmentManager LIKE '%Smith%' AND  S.id=E.Department_id
)
GO
--ANY
SELECT *FROM [Employees] E
WHERE E.Department_id = ANY(
 SELECT S.id FROM [StructuralDepartments] S
 WHERE S.DepartmentManager LIKE '%Smith%' AND  S.id=E.Department_id
)
GO

--6.SELECT � ������������� ������������� �� ����������
SELECT Employee_id, SUM(Deductions) FROM [dbo].[SalaryPayments]
GROUP BY (Employee_id);
GO

--7.SELECT � ������������� ��-������ � ������ Where
SELECT *FROM [Employees] E
WHERE E.Department_id != ALL(
 SELECT S.id FROM [StructuralDepartments] S
 WHERE S.DepartmentManager LIKE '%Smith%' AND  S.id=E.Department_id
)
GO

--9.����������� SELECT?�����
--�������� �� ����������� ���� ����� �����

--10.SELECT?����� ���� CrossTab
SELECT * FROM [dbo].[Employees] 
CROSS JOIN [dbo].[HourlyRates]
GO

--11.UPDATE �� ��� ���� �������
UPDATE [Employees] SET FirstName='TEST'
WHERE FirstName='David'
GO

--12.UPDATE �� ��� ������ �������
UPDATE [Employees] SET FirstName='David'
FROM [Employees] E
 JOIN [Vacations] V  ON V.Employee_id=E.id 
WHERE V.id=1 AND E.FirstName='TEST'
GO

--13.Append (INSERT) ��� ��������� ������ � ���� ��������� ����������
INSERT INTO [dbo].[WorkTime]
	([WorkDate],[Employee_id],[WorkHours])
VALUES('2023-29-05','3','8');
GO

--14.Append (INSERT) ��� ��������� ������ � ����� �������
DROP TABLE IF EXISTS [Temp]
GO
CREATE TABLE [Temp](
 [id] [int] NOT NULL, [PositionName] NVARCHAR(50) NOT NULL,
 CONSTRAINT [PK_Temp] PRIMARY KEY CLUSTERED (
 [id] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT INTO [Temp]  ([id],[PositionName]) 
VALUES  (1,'VASA'),
 (2,'POOF')
GO
SELECT * FROM [Positions]
GO
INSERT INTO [Positions]SELECT T.PositionName FROM [Temp] T
GO
SELECT * FROM [Positions]
GO
DROP TABLE IF EXISTS [Temp]
GO

--15.DELETE ��� ��������� ��� ����� � �������
DROP TABLE IF EXISTS [Temp]
GO
CREATE TABLE [Temp](
 [id] [int] NOT NULL, [PositionName] NVARCHAR(50) NOT NULL,
 CONSTRAINT [PK_Temp] PRIMARY KEY CLUSTERED (
 [id] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SELECT * FROM [Temp]GO
INSERT INTO [Temp] 
 ([id],[PositionName]) VALUES 
 (1,'VASA'), (2,'POOF')
GO
SELECT * FROM [Temp]
GO
DELETE FROM [Temp]
GO
SELECT * FROM [Temp]
GO
DROP TABLE IF EXISTS [Temp]
GO

--16.DELETE ��� ��������� �������� ������ �������.
DROP TABLE IF EXISTS [Temp]GO
CREATE TABLE [Temp](
 [id] [int] NOT NULL, [PositionName] NVARCHAR(50) NOT NULL,
 CONSTRAINT [PK_Temp] PRIMARY KEY CLUSTERED (
 [id] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SELECT * FROM [Temp]
GO
INSERT INTO [Temp] 
 ([id],[PositionName]) VALUES 
 (1,'VASA'), (2,'Something')
GO
SELECT * FROM [Temp]GO
DELETE FROM [Temp] WHERE [PositionName]='Something'
GO
SELECT * FROM [Temp]
GO
DROP TABLE IF EXISTS [Temp]
GO