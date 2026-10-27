-- US-03: Returns the ten sites with the highest Type 1 episode share waiting over 12 hours.
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1'
      AND AttendanceCategory = 'All'
),
site_totals AS (
    SELECT
        HBName AS HealthBoard,
        TreatmentLocation AS SiteCode,
        HospitalName AS Site,
        SUM(NumberOver12HoursEpisode) AS Over12Hours,
        SUM(NumberOfAttendancesEpisode) AS Attendances,
        SUM(NumberOver12HoursEpisode) * 100.0
            / NULLIF(SUM(NumberOfAttendancesEpisode), 0) AS PercentageOver12Hours
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1'
      AND AttendanceCategory = 'All'
      AND date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
      AND NumberOfAttendancesEpisode IS NOT NULL
      AND NumberOver12HoursEpisode IS NOT NULL
    GROUP BY HBName, TreatmentLocation, HospitalName
    HAVING SUM(NumberOfAttendancesEpisode) >= 500
)
SELECT HealthBoard, SiteCode, Site, Attendances, Over12Hours, PercentageOver12Hours
FROM site_totals
ORDER BY PercentageOver12Hours DESC, Attendances DESC, HealthBoard, SiteCode
LIMIT 10;