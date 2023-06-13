--À¿¡Œ–¿“Œ–Õ¿ –Œ¡Œ“¿ π5
CREATE LOGIN controller_Steve WITH PASSWORD='Stevie04';
CREATE USER controller FOR LOGIN controller_Steve;
GRANT SELECT, INSERT ON [WorkTime] TO controller;
GO
EXECUTE AS LOGIN = 'controller_Steve';
PRINT 'Using account of controller_Steve'
SELECT *FROM [dbo].[WorkTime] W
SELECT *FROM [dbo].[Employees] E
PRINT 'Exiting account'
REVERT 
GO

CREATE LOGIN cashier_Stacey WITH PASSWORD='St4ci_';
CREATE USER cashier FOR LOGIN cashier_Stacey;
GRANT SELECT, INSERT ON [SalaryPayments] TO cashier;
GO
EXECUTE AS LOGIN = 'cashier_Stacey';
PRINT 'Using account of cashier_Stacey'
SELECT *FROM [dbo].[SalaryPayments] SP
SELECT *FROM [dbo].[Employees] E
PRINT 'Exiting account'
REVERT
GO

CREATE LOGIN HR_specialist_Bob WITH PASSWORD='As4r45';
CREATE USER HR_specialist FOR LOGIN HR_specialist_Bob;
GRANT SELECT, INSERT ON [Employees] TO HR_specialist;
GO
EXECUTE AS LOGIN = 'HR_specialist_Bob';
PRINT 'Using account of HR_specialist_Bob'
SELECT *FROM [dbo].[Employees] E
SELECT *FROM [dbo].[SalaryPayments] SP
PRINT 'Exiting account'
REVERT
GO

CREATE ROLE Manager;
CREATE ROLE Employee;
ALTER SCHEMA [back] TRANSFER [HourlyRates];ALTER SCHEMA [back] TRANSFER [Vacations];
ALTER SCHEMA [back] TRANSFER [SalaryPayments];ALTER SCHEMA [front] TRANSFER [Employees];
ALTER SCHEMA [front] TRANSFER [StructuralDepartments];ALTER SCHEMA [front] TRANSFER [Positions];
ALTER SCHEMA [front] TRANSFER [WorkTime];
GRANT SELECT 
ON SCHEMA::back TO Employee;
GRANT SELECT, INSERT, DELETE, UPDATE 
ON SCHEMA::front TO Manager;
GRANT SELECT, INSERT, DELETE, UPDATE
ON SCHEMA::back TO Manager;
GO
CREATE LOGIN Manager_Irving WITH PASSWORD='Irv394d';
CREATE USER Manager_Irving FOR LOGIN Manager_Irving;
ALTER ROLE Manager ADD MEMBER Manager_Irving;
GO
EXECUTE AS LOGIN = 'Manager_Irving';
PRINT 'Using account of Manager_Irving'
SELECT *FROM [dbo].[Employees] E
SELECT *FROM [dbo].[SalaryPayments] SP
PRINT 'Exiting account'
REVERT 
GO

CREATE LOGIN Employee_George WITH PASSWORD='Ge594r';
CREATE USER Employee_George FOR LOGIN Employee_George;
ALTER ROLE Employee ADD MEMBER Employee_George;
GO
EXECUTE AS LOGIN = 'Employee_George';
PRINT 'Using account of Employee_George'
SELECT *
FROM [dbo].[WorkTime] W
SELECT *FROM [dbo].[Vacations] V
PRINT 'Exiting account'
REVERT
GO

CREATE LOGIN Accountant_Harry WITH PASSWORD='H2r56';
CREATE USER Accountant_Harry FOR LOGIN Accountant_Harry;
GRANT SELECT ON [front].[Employees] TO Accountant_Harry;
ALTER ROLE Employee ADD MEMBER Accountant_Harry;
DENY SELECT ON [back].[HourlyRates]
TO Accountant_Harry;
GO
EXECUTE AS LOGIN = 'Accountant_Harry';
PRINT 'Using account of Accountant_Harry'
SELECT *FROM [front].[Employees] E
SELECT *FROM [back].[SalaryPayments] SP
PRINT 'Exiting account'
REVERT
GO

EXEC sp_droprolemember 'Employee', 'Accountant_Harry';
GO
EXECUTE AS LOGIN = 'Accountant_Harry';
PRINT 'Using account of Accountant_Harry'
SELECT *FROM [front].[Employees] E
SELECT *FROM [back].[SalaryPayments] SP
SELECT *FROM [back].[HourlyRates] H
PRINT 'Exiting account'
REVERT 
GO
DROP USER Accountant_Harry;
EXEC sp_droprolemember 'Employee', 'Employee_George';
GO 
DROP ROLE Employee;
ALTER SCHEMA [dbo] TRANSFER [back].[HourlyRates];
ALTER SCHEMA [dbo] TRANSFER [back].[Vacations];ALTER SCHEMA [dbo] TRANSFER [back].[SalaryPayments];
ALTER SCHEMA [dbo] TRANSFER [front].[Employees];
ALTER SCHEMA [dbo] TRANSFER [front].[StructuralDepartments];ALTER SCHEMA [dbo] TRANSFER [front].[Positions];
ALTER SCHEMA [dbo] TRANSFER [front].[WorkTime];
GO