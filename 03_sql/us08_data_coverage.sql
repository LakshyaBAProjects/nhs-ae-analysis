-- US-08: Lists every Type 1 site in the latest 12 months with a flag for unnamed sites and sites too small to rank (under 500 attendances).
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1' AND AttendanceCategory = 'All'
)
SELECT HBName AS HealthBoard,
       TreatmentLocation AS SiteCode,
       HospitalName AS Site,
       SUM(NumberOfAttendancesEpisode) AS Attendances,
       CASE
           WHEN HospitalName LIKE 'Unknown site%' THEN 'Site name not in lookup'
           WHEN SUM(NumberOfAttendancesEpisode) < 500 THEN 'Excluded from rankings (under 500)'
           ELSE 'Included in rankings'
       END AS RankingStatus
FROM ae_monthly
WHERE DepartmentType = 'Type 1' AND AttendanceCategory = 'All'
  AND date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
  AND NumberOfAttendancesEpisode IS NOT NULL
GROUP BY HBName, TreatmentLocation, HospitalName
ORDER BY RankingStatus, Attendances DESC;
