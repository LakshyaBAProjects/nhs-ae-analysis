-- US-07: Monthly share of Type 1 ED patients waiting over 8 hours and over 12 hours in Scotland, from January 2019.
SELECT date(Month) AS Month,
       SUM(NumberOfAttendancesEpisode) AS Attendances,
       ROUND(SUM(NumberOver8HoursEpisode) * 100.0 / NULLIF(SUM(NumberOfAttendancesEpisode), 0), 2) AS PctOver8Hours,
       ROUND(SUM(NumberOver12HoursEpisode) * 100.0 / NULLIF(SUM(NumberOfAttendancesEpisode), 0), 2) AS PctOver12Hours
FROM ae_monthly
WHERE DepartmentType = 'Type 1' AND AttendanceCategory = 'All'
  AND date(Month) >= '2019-01-01'
  AND NumberOfAttendancesEpisode IS NOT NULL
GROUP BY date(Month)
ORDER BY Month;
