-- US-02: Ranks every board by its Type 1 episode-based four-hour performance over 12 months.
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1'
      AND AttendanceCategory = 'All'
),
all_boards AS (
    SELECT DISTINCT HBName AS HealthBoard
    FROM ae_monthly
),
site_totals AS (
    SELECT
        HBName AS HealthBoard,
        TreatmentLocation AS SiteCode,
        HospitalName AS Site,
        SUM(NumberWithin4HoursEpisode) AS Within4Hours,
        SUM(NumberOfAttendancesEpisode) AS Attendances
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1'
      AND AttendanceCategory = 'All'
    AND date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
      AND NumberOfAttendancesEpisode IS NOT NULL
      AND NumberWithin4HoursEpisode IS NOT NULL
    GROUP BY HBName, TreatmentLocation, HospitalName
    HAVING SUM(NumberOfAttendancesEpisode) >= 500
),
board_totals AS (
    SELECT
        HealthBoard,
        SUM(Within4Hours) AS Within4Hours,
        SUM(Attendances) AS Attendances,
        SUM(Within4Hours) * 100.0 / NULLIF(SUM(Attendances), 0) AS PercentageWithin4Hours
    FROM site_totals
    GROUP BY HealthBoard
),
ranked_boards AS (
    SELECT
        all_boards.HealthBoard,
        board_totals.PercentageWithin4Hours,
        board_totals.Attendances,
        RANK() OVER (
            ORDER BY
                CASE WHEN board_totals.PercentageWithin4Hours IS NULL THEN 1 ELSE 0 END,
                board_totals.PercentageWithin4Hours DESC
        ) AS PerformanceRank
    FROM all_boards
    LEFT JOIN board_totals USING (HealthBoard)
)
SELECT PerformanceRank, HealthBoard, PercentageWithin4Hours, Attendances
FROM ranked_boards
ORDER BY PerformanceRank, HealthBoard;