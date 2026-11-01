-- US-10: Compares each board's delayed-discharge pressure with its A&E performance over the latest 12 months (Type 1 EDs, adults 18+ for delays).
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date FROM board_month_flow
)
SELECT HBName AS HealthBoard,
       SUM(Attendances)                                                    AS Attendances,
       ROUND(SUM(Within4h) * 100.0 / SUM(Attendances), 1)                  AS PctWithin4h,
       ROUND(SUM(Over12h)  * 100.0 / SUM(Attendances), 1)                  AS PctOver12h,
       ROUND(SUM(AvgDailyDelayedBeds) * 1.0 / COUNT(*), 0)                       AS AvgDailyDelayedBeds,
       ROUND(SUM(DelayedBedDays) * 1000.0 / SUM(Attendances), 0)           AS DelayedBedDaysPer1000Attendances
FROM board_month_flow
WHERE date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
GROUP BY HBName
ORDER BY PctWithin4h;
