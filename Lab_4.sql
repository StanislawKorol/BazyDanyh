--ЛАБОРАТОРНА РОБОТА №4
--Заповнення та створення додаткових полів
ALTER TABLE Employees ADD UCR VARCHAR(255);
ALTER TABLE Employees ADD DCR DATETIME;
ALTER TABLE Employees ADD ULC VARCHAR(255);
ALTER TABLE Employees ADD DLC DATETIME;
CREATE TRIGGER TRG_Employees_Insert
ON Employees FOR INSERT 
AS
BEGIN
    UPDATE Employees SET UCR = SUSER_SNAME(), DCR = GETDATE(), ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE Employees.id = inserted.id;
END;
CREATE TRIGGER TRG_Employees_Update
ON Employees
FOR UPDATE
AS
BEGIN
    UPDATE Employees SET ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE Employees.id = inserted.id;
END;

ALTER TABLE HourlyRates ADD UCR VARCHAR(255);
ALTER TABLE HourlyRates ADD DCR DATETIME;
ALTER TABLE HourlyRates ADD ULC VARCHAR(255);
ALTER TABLE HourlyRates ADD DLC DATETIME;
CREATE TRIGGER TRG_HourlyRates_Insert
ON HourlyRates FOR INSERT 
AS
BEGIN
    UPDATE HourlyRates SET UCR = SUSER_SNAME(), DCR = GETDATE(), ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE HourlyRates.id = inserted.id;
END;
CREATE TRIGGER TRG_HourlyRates_Update
ON HourlyRates
FOR UPDATE
AS
BEGIN
    UPDATE HourlyRates SET ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE HourlyRates.id = inserted.id;
END;

ALTER TABLE Positions ADD UCR VARCHAR(255);
ALTER TABLE Positions ADD DCR DATETIME;
ALTER TABLE Positions ADD ULC VARCHAR(255);
ALTER TABLE Positions ADD DLC DATETIME;
CREATE TRIGGER TRG_Positions_Insert
ON Positions FOR INSERT 
AS
BEGIN
    UPDATE Positions SET UCR = SUSER_SNAME(), DCR = GETDATE(), ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE Positions.id = inserted.id;
END;
CREATE TRIGGER TRG_Positions_Update
ON Positions
FOR UPDATE
AS
BEGIN
    UPDATE Positions SET ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE Positions.id = inserted.id;
END;

ALTER TABLE SalaryPayments ADD UCR VARCHAR(255);
ALTER TABLE SalaryPayments ADD DCR DATETIME;
ALTER TABLE SalaryPayments ADD ULC VARCHAR(255);
ALTER TABLE SalaryPayments ADD DLC DATETIME;
CREATE TRIGGER TRG_SalaryPayments_Insert
ON SalaryPayments FOR INSERT 
AS
BEGIN
    UPDATE SalaryPayments SET UCR = SUSER_SNAME(), DCR = GETDATE(), ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE SalaryPayments.id = inserted.id;
END;
CREATE TRIGGER TRG_SalaryPayments_Update
ON SalaryPayments
FOR UPDATE
AS
BEGIN
    UPDATE SalaryPayments SET ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE SalaryPayments.id = inserted.id;
END;

ALTER TABLE StructuralDepartments ADD UCR VARCHAR(255);
ALTER TABLE StructuralDepartments ADD DCR DATETIME;
ALTER TABLE StructuralDepartments ADD ULC VARCHAR(255);
ALTER TABLE StructuralDepartments ADD DLC DATETIME;
CREATE TRIGGER TRG_StructuralDepartments_Insert
ON StructuralDepartments FOR INSERT 
AS
BEGIN
    UPDATE StructuralDepartments SET UCR = SUSER_SNAME(), DCR = GETDATE(), ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE StructuralDepartments.id = inserted.id;
END;
CREATE TRIGGER TRG_StructuralDepartments_Update
ON StructuralDepartments
FOR UPDATE
AS
BEGIN
    UPDATE StructuralDepartments SET ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE StructuralDepartments.id = inserted.id;
END;

ALTER TABLE Vacations ADD UCR VARCHAR(255);
ALTER TABLE Vacations ADD DCR DATETIME;
ALTER TABLE Vacations ADD ULC VARCHAR(255);
ALTER TABLE Vacations ADD DLC DATETIME;
CREATE TRIGGER TRG_Vacations_Insert
ON Vacations FOR INSERT 
AS
BEGIN
    UPDATE Vacations SET UCR = SUSER_SNAME(), DCR = GETDATE(), ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE Vacations.id = inserted.id;
END;
CREATE TRIGGER TRG_Vacations_Update
ON Vacations
FOR UPDATE
AS
BEGIN
    UPDATE Vacations SET ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE Vacations.id = inserted.id;
END;

ALTER TABLE WorkTime ADD UCR VARCHAR(255);
ALTER TABLE WorkTime ADD DCR DATETIME;
ALTER TABLE WorkTime ADD ULC VARCHAR(255);
ALTER TABLE WorkTime ADD DLC DATETIME;
CREATE TRIGGER TRG_WorkTime_Insert
ON WorkTime FOR INSERT 
AS
BEGIN
    UPDATE WorkTime SET UCR = SUSER_SNAME(), DCR = GETDATE(), ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE WorkTime.id = inserted.id;
END;
CREATE TRIGGER TRG_WorkTime_Update
ON WorkTime
FOR UPDATE
AS
BEGIN
    UPDATE WorkTime SET ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE WorkTime.id = inserted.id;
END;

ALTER TABLE _Salary ADD UCR VARCHAR(255);
ALTER TABLE _Salary ADD DCR DATETIME;
ALTER TABLE _Salary ADD ULC VARCHAR(255);
ALTER TABLE _Salary ADD DLC DATETIME;
CREATE TRIGGER TRG__Salary_Insert
ON _Salary FOR INSERT 
AS
BEGIN
    UPDATE _Salary SET UCR = SUSER_SNAME(), DCR = GETDATE(), ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE _Salary.Employee_id = inserted.Employee_id;
END;
CREATE TRIGGER TRG__Salary_Update
ON _Salary
FOR UPDATE
AS
BEGIN
    UPDATE _Salary SET ULC = SUSER_SNAME(), DLC = GETDATE()
    FROM inserted WHERE _Salary.Employee_id = inserted.Employee_id;
END;

--Сурогатний ключ
ALTER TABLE [dbo].[Employees] ADD [Emp_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL;
CREATE TRIGGER tr_Employee_emp_id
ON [dbo].[Employees]
INSTEAD OF INSERT
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO [dbo].[Employees] ([id], [LastName], [FirstName], [MiddleName], [PassportData], [DateOfBirth], [PlaceOfBirth], [HomeAddress],[Position_id],[Department_id])
  SELECT ROW_NUMBER() OVER (ORDER BY [id]),[LastName], [FirstName], [MiddleName], [PassportData], [DateOfBirth], [PlaceOfBirth], [HomeAddress],[Position_id],[Department_id]
  FROM inserted;
END;

--Працівник не може бути на двох і більше посадах одночасно
CREATE TRIGGER TRG_Employees_Positions_Unique
ON Employees
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Positions
        WHERE id IN (SELECT id FROM inserted)
    )
    BEGIN
        RAISERROR ('Employee already has a position in another department', 16, 1);
        ROLLBACK TRANSACTION; 
        RETURN;
    END;
END;

--Зарплатня не може бути менше за мінімальну зарплатню
CREATE TRIGGER TRG_Salary_Min_Salary
ON SalaryPayments
INSTEAD OF INSERT
AS
BEGIN
    IF (SELECT NetSalary FROM inserted) < 500
    BEGIN
        RAISERROR ('Employee basic salary cannot be less than the minimum salary for their position', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

--Звільнений працівник не може отримувати зарплатню
CREATE TRIGGER TRG_Employees_Termination
ON _Salary
AFTER INSERT, UPDATE
AS
BEGIN
  DECLARE @termination_date DATE;
  SELECT @termination_date = DATEADD(DAY, 1, '2023-10-05') FROM Employees
  WHERE id = (SELECT Employee_id FROM inserted);

  IF EXISTS(SELECT 1 FROM inserted WHERE [Month_Year] > @termination_date)
  BEGIN
    RAISERROR ('Employee cannot accrue salary after their termination date.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
  END;
END;