-- US-06: Compares each board's share seen within 4 hours in 2019 (pre-pandemic baseline) with the latest 12 months (Type 1 EDs).
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1' AND AttendanceCategory = 'All'
),
baseline AS (
    SELECT HBName AS HealthBoard,
           SUM(NumberWithin4HoursEpisode) * 100.0 / NULLIF(SUM(NumberOfAttendancesEpisode), 0) AS Pct2019
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1' AND AttendanceCategory = 'All'
      AND date(Month) BETWEEN '2019-01-01' AND '2019-12-01'
      AND NumberOfAttendancesEpisode IS NOT NULL
    GROUP BY HBName
),
latest AS (
    SELECT HBName AS HealthBoard,
           SUM(NumberWithin4HoursEpisode) * 100.0 / NULLIF(SUM(NumberOfAttendancesEpisode), 0) AS PctLatest12m
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1' AND AttendanceCategory = 'All'
      AND date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
      AND NumberOfAttendancesEpisode IS NOT NULL
    GROUP BY HBName
)
SELECT baseline.HealthBoard,
       ROUND(Pct2019, 1) AS Pct2019,
       ROUND(PctLatest12m, 1) AS PctLatest12m,
       ROUND(PctLatest12m - Pct2019, 1) AS ChangeInPoints
FROM baseline
JOIN latest USING (HealthBoard)
ORDER BY ChangeInPoints;
