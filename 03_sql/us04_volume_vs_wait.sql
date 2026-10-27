-- US-04: Compares Type 1 episode volume and four-hour performance by site, flagging paediatric hospitals.
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date
    FROM ae_monthly
    WHERE DepartmentType = 'Type 1'
      AND AttendanceCategory = 'All'
)
SELECT
    HBName AS HealthBoard,
    TreatmentLocation AS SiteCode,
    HospitalName AS Site,
    CASE
      WHEN TRIM(HospitalName) IN (
        'Royal Hospital for Children',
        'Royal Hospital for Children and Young People'
      ) OR TreatmentLocation = 'S319H' THEN 1
      ELSE 0
    END AS IsPaediatric,
    SUM(NumberOfAttendancesEpisode) AS Attendances,
    SUM(NumberWithin4HoursEpisode) * 100.0
        / NULLIF(SUM(NumberOfAttendancesEpisode), 0) AS PercentageWithin4Hours
FROM ae_monthly
WHERE DepartmentType = 'Type 1'
  AND AttendanceCategory = 'All'
  AND date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
  AND NumberOfAttendancesEpisode IS NOT NULL
  AND NumberWithin4HoursEpisode IS NOT NULL
GROUP BY HBName, TreatmentLocation, HospitalName
HAVING SUM(NumberOfAttendancesEpisode) > 0
ORDER BY Attendances DESC, HealthBoard, SiteCode;