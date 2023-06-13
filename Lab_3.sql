--ЛАБОРАТОРНА РОБОТА №3
--Процедура нарахування зарплати працівнику
CREATE TABLE _Salary(
  Employee_id INT NOT NULL,
  Month_Year DATETIME NOT NULL,
  Taxation INT NOT NULL,
  Basic_Salary INT NOT NULL,
  Vacation INT NOT NULL,
  Salary INT NOT NULL
)
GO

ALTER PROCEDURE CalculateSalary
  @employeeId INT,
  @month DATETIME
AS
BEGIN
  DECLARE @basicSalary DECIMAL(10,2)
  DECLARE @taxation DECIMAL(10,2)
  DECLARE @vacation INT
  DECLARE @vacationPayment DECIMAL(10,2)

  SELECT @basicSalary = H.HourlyRate * SUM(WT.WorkHours) 
  FROM [HourlyRates] H
  INNER JOIN Employees E ON H.id = E.id
  INNER JOIN SalaryPayments SP ON E.id = SP.id
  INNER JOIN WorkTime WT ON SP.id = WT.Employee_id
  WHERE E.id = @employeeId AND @month = SP.MonthYear
  GROUP BY H.HourlyRate

  SELECT @vacation = V.Duration
  FROM Vacations V
  WHERE V.Employee_id = @employeeId AND @month BETWEEN V.StartDate AND V.EndDate  
  SET @vacationPayment = IIF(@vacation !=0, @basicSalary / (30 * @vacation),0)

  DELETE FROM [dbo].[_Salary] WHERE Employee_id=@employeeId AND Month_Year= @month;
  INSERT INTO _Salary (Employee_id, Month_Year, Taxation, Basic_Salary, Vacation, Salary)
  VALUES (@employeeId, @month, 0.2*@basicSalary, @basicSalary, @vacationPayment, @basicSalary + @vacationPayment - 0.2*@basicSalary)
END

EXECUTE CalculateSalary 1,'2023-06-10'
GO


--Нарахування зарплати для всіх працівників
CREATE PROCEDURE CalculateSalaryForAllEmployees
  @month DATETIME
AS
BEGIN
  DECLARE @employeeId INT
  DECLARE employee_cursor CURSOR FOR
    SELECT id FROM Employees
  OPEN employee_cursor
  FETCH NEXT FROM employee_cursor INTO @employeeId
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXEC CalculateSalary @employeeId, @month
    FETCH NEXT FROM employee_cursor INTO @employeeId
  END
  CLOSE employee_cursor
  DEALLOCATE employee_cursor
END

EXECUTE CalculateSalaryForAllEmployees '2023-06-10'
GO
