-- US-05: Finds the calendar months with the lowest average Type 1 episode share seen within four hours since 2022.
WITH monthly_performance AS (
    SELECT
        strftime('%m', Month) AS MonthNumber,
        strftime('%Y-%m', Month) AS YearMonth,
        SUM(NumberWithin4HoursEpisode) * 100.0
            / NULLIF(SUM(NumberOfAttendancesEpisode), 0) AS PercentageWithin4Hours
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1'
      AND AttendanceCategory = 'All'
            -- Focus on recent service conditions rather than mixing in older historical patterns.
            AND date(Month) >= date('2022-01-01')
      AND NumberOfAttendancesEpisode IS NOT NULL
      AND NumberWithin4HoursEpisode IS NOT NULL
    GROUP BY strftime('%Y-%m', Month), strftime('%m', Month)
    HAVING SUM(NumberOfAttendancesEpisode) > 0
)
SELECT
    MonthNumber,
    CASE MonthNumber
        WHEN '01' THEN 'January'
        WHEN '02' THEN 'February'
        WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'
        WHEN '08' THEN 'August'
        WHEN '09' THEN 'September'
        WHEN '10' THEN 'October'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'December'
    END AS CalendarMonth,
    AVG(PercentageWithin4Hours) AS AveragePercentageWithin4Hours,
    COUNT(*) AS YearsIncluded
FROM monthly_performance
GROUP BY MonthNumber
ORDER BY AveragePercentageWithin4Hours, MonthNumber;