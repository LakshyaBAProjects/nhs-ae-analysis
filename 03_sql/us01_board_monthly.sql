-- US-01: Shows the monthly share of Type 1 episodes seen within four hours for a selected board.
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1'
      AND AttendanceCategory = 'All'
),
board_months AS (
    SELECT
        date(Month) AS Month,
        HBName AS HealthBoard,
        SUM(NumberWithin4HoursEpisode) * 100.0
            / NULLIF(SUM(NumberOfAttendancesEpisode), 0) AS PercentageWithin4Hours,
        SUM(NumberOfAttendancesEpisode) AS Attendances
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1'
      AND AttendanceCategory = 'All'
      AND HBName = :board_name
    AND date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
      AND NumberOfAttendancesEpisode IS NOT NULL
      AND NumberWithin4HoursEpisode IS NOT NULL
    GROUP BY date(Month), HBName
)
SELECT Month, HealthBoard, PercentageWithin4Hours, Attendances
FROM board_months
ORDER BY Month;