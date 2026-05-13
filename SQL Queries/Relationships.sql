USE WorkplaceBurnout;
GO


/*alternative import workflow*/
ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Departments
FOREIGN KEY (DepartmentID)
REFERENCES Departments(ID);


ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_WorkMode
FOREIGN KEY (WorkModeID)
REFERENCES WorkMode(ID);

ALTER TABLE DailyWorkMetrics
ADD CONSTRAINT FK_DailyWorkMetrics_Employees
FOREIGN KEY (EmployeeID)
REFERENCES Employees(EmployeeID);

ALTER TABLE WellbeingMetrics
ADD CONSTRAINT FK_WellbeingMetrics_Employees
FOREIGN KEY (EmployeeID)
REFERENCES Employees(EmployeeID);

ALTER TABLE BurnoutScores
ADD CONSTRAINT FK_BurnoutScores_Employees
FOREIGN KEY (EmployeeID)
REFERENCES Employees(EmployeeID);

ALTER TABLE BurnoutScores
ADD CONSTRAINT FK_BurnoutScores_Risk
FOREIGN KEY (RiskID)
REFERENCES Risk(ID);

GO

ALTER TABLE DailyWorkMetrics
ADD CONSTRAINT UQ_DailyWorkMetrics_Employee_Date
UNIQUE (EmployeeID, Date);

ALTER TABLE WellbeingMetrics
ADD CONSTRAINT UQ_WellbeingMetrics_Employee_Date
UNIQUE (EmployeeID, Date);

ALTER TABLE BurnoutScores
ADD CONSTRAINT UQ_BurnoutScores_Employee_Date
UNIQUE (EmployeeID, Date);

GO