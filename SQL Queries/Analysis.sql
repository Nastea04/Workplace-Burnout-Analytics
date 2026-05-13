use WorkplaceBurnout
Go

CREATE VIEW BurnoutAnalyticsView AS
SELECT
    b.ID,
    b.EmployeeID,
    b.Date,
    e.Role,
    e.SeniorityLevel,
    d.Name AS Department,
    w.Type AS WorkMode,
    b.BurnoutScore,
    r.Type AS RiskLevel,
    b.MainRiskFactor,
    b.Overtime,
    b.MeetingsCount,
    b.FocusHours,
    b.TasksPending,
    b.SleepHours,
    b.StressLevel,
    b.EnergyLevel,
    b.BreaksTaken,
    b.Adjustment
FROM BurnoutScores b
JOIN Employees e ON b.EmployeeID = e.EmployeeID
JOIN Departments d ON e.DepartmentID = d.ID
JOIN WorkMode w ON e.WorkModeID = w.ID
JOIN Risk r ON b.RiskID = r.ID;

/*Burnout by department*/
WITH DepartmentStatistics AS (
    SELECT
        d.Name AS Department,
        AVG(b.BurnoutScore) AS AverageBurnoutScore,
        AVG(b.StressLevel) AS AverageStressLevel,
        COUNT(*) AS RecordsCount
    FROM BurnoutScores b
    JOIN Employees e ON b.EmployeeID = e.EmployeeID
    JOIN Departments d ON e.DepartmentID = d.ID
    GROUP BY d.Name
),

MostCommonRiskFactor AS (
    SELECT
        d.Name AS Department,
        b.MainRiskFactor,
        COUNT(*) AS FactorCount,
        ROW_NUMBER() OVER (
            PARTITION BY d.Name
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM BurnoutScores b
    JOIN Employees e ON b.EmployeeID = e.EmployeeID
    JOIN Departments d ON e.DepartmentID = d.ID
    GROUP BY d.Name, b.MainRiskFactor
)

SELECT
    ds.Department,

    FORMAT(ds.AverageBurnoutScore, 'N2') AS AverageBurnoutScore,

    FORMAT(ds.AverageStressLevel, 'N2') AS AverageStressLevel,

    ds.RecordsCount,

    CASE
        WHEN ds.AverageBurnoutScore <= 30 THEN 'Low'
        WHEN ds.AverageBurnoutScore <= 50 THEN 'Medium'
        WHEN ds.AverageBurnoutScore <= 80 THEN 'High'
        ELSE 'Critical'
    END AS AverageRiskLevel,

    rf.MainRiskFactor AS MostCommonRiskFactor

FROM DepartmentStatistics ds

LEFT JOIN MostCommonRiskFactor rf
    ON ds.Department = rf.Department
    AND rf.rn = 1

ORDER BY ds.AverageBurnoutScore DESC;

/*Burnout by Workmode"*/
SELECT
    w.Type AS WorkMode,
    FORMAT(AVG(b.BurnoutScore),'N2') AS AvgBurnoutScore,
    AVG(b.StressLevel) AS AvgStressLevel,
    FORMAT(AVG(b.FocusHours),'N2') AS AvgFocusHours
FROM BurnoutScores b
JOIN Employees e ON b.EmployeeID = e.EmployeeID
JOIN WorkMode w ON e.WorkModeID = w.ID
GROUP BY w.Type
ORDER BY AvgBurnoutScore DESC;

/*Common main risk factors*/
SELECT
    MainRiskFactor,
    COUNT(*) AS Occurrences,
    FORMAT(AVG(BurnoutScore),'N2') AS AvgBurnoutScore
FROM BurnoutScores
GROUP BY MainRiskFactor
ORDER BY Occurrences DESC;

/*Employees at High and Critical risk*/
SELECT
    b.EmployeeID,
    e.Role,
    d.Name AS Department,
    b.Date,
    b.BurnoutScore,
    r.Type AS RiskLevel,
    b.MainRiskFactor
FROM BurnoutScores b
JOIN Employees e ON b.EmployeeID = e.EmployeeID
JOIN Departments d ON e.DepartmentID = d.ID
JOIN Risk r ON b.RiskID = r.ID
WHERE b.RiskID IN (3, 4)
ORDER BY b.BurnoutScore DESC;

/*Burnout by date*/
SELECT
    Date,
    FORMAT(AVG(BurnoutScore),'N2') AS AverageBurnoutScore,
    FORMAT(AVG(StressLevel),'N2') AS AverageStressLevel,
    FORMAT(AVG(EnergyLevel),'N2') AS AverageEnergyLevel
FROM BurnoutScores
GROUP BY Date
ORDER BY Date;

/*Top 10 overloaded employees*/
SELECT TOP 10
    b.EmployeeID,
    e.Role,
    FORMAT(AVG(b.BurnoutScore),'N2') AS AverageBurnout,
    FORMAT(AVG(b.Overtime),'N2') AS AverageOvertime,
    FORMAT(AVG(b.MeetingsCount),'N2') AS AverageMeetings,
    FORMAT(AVG(b.TasksPending),'N2') AS AveragePendingTasks
FROM BurnoutScores b
JOIN Employees e ON b.EmployeeID = e.EmployeeID
GROUP BY b.EmployeeID, e.Role
ORDER BY AVG(b.BurnoutScore) DESC;
