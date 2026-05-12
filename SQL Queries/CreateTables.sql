CREATE DATABASE WorkplaceBurnout;
Go
USE WorkplaceBurnout;
Go

CREATE TABLE Departments (
    ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    ManagerID INT
);

CREATE TABLE WorkMode (
    ID INT PRIMARY KEY,
    Type VARCHAR(30) NOT NULL,
    Adjustment INT NOT NULL
);

CREATE TABLE Risk (
    ID INT PRIMARY KEY,
    Type VARCHAR(30) NOT NULL,
    MinScore INT NOT NULL,
    MaxScore INT NOT NULL,
    Action VARCHAR(255)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT NOT NULL,
    WorkModeID INT NOT NULL,
    Role VARCHAR(50),
    SeniorityLevel VARCHAR(30),
    HireDate DATE,

    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentID)
        REFERENCES Departments(ID),

    CONSTRAINT FK_Employees_WorkMode
        FOREIGN KEY (WorkModeID)
        REFERENCES WorkMode(ID)
);

CREATE TABLE DailyWorkMetrics (
    ID INT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Date DATE NOT NULL,
    WorkHours DECIMAL(4,1),
    Overtime DECIMAL(4,1),
    MeetingsCount INT,
    MeetingHours DECIMAL(4,1),
    FocusHours DECIMAL(4,1),
    TasksCompleted INT,
    TasksPending INT,

    CONSTRAINT FK_DailyWorkMetrics_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

CREATE TABLE WellbeingMetrics (
    ID INT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Date DATE NOT NULL,
    SleepHours DECIMAL(4,1),
    StressLevel INT,
    EnergyLevel INT,
    MoodScore INT,
    BreaksTaken INT,

    CONSTRAINT FK_WellbeingMetrics_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

CREATE TABLE BurnoutScores (
    ID INT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Date DATE NOT NULL,
    BurnoutScore DECIMAL(5,2),
    RiskID INT,
    MainRiskFactor VARCHAR(100),

    Overtime DECIMAL(4,1),
    MeetingsCount INT,
    FocusHours DECIMAL(4,1),
    TasksPending INT,
    SleepHours DECIMAL(4,1),
    StressLevel INT,
    EnergyLevel INT,
    BreaksTaken INT,
    Adjustment INT,

    CONSTRAINT FK_BurnoutScores_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID),

    CONSTRAINT FK_BurnoutScores_Risk
        FOREIGN KEY (RiskID)
        REFERENCES Risk(ID)
);



