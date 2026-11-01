-- US-09: Shows the monthly national trend in delayed-discharge bed days and average daily delayed beds, next to Type 1 A&E attendances.
-- Source table board_month_flow: 14 health boards, adults 18+, "All Delay Reasons" only (no double counting, Scotland total excluded).
SELECT Month,
       SUM(DelayedBedDays)                                     AS DelayedBedDays,
       SUM(AvgDailyDelayedBeds)                                AS AvgDailyDelayedBeds,
       SUM(Attendances)                                        AS Type1Attendances,
       ROUND(SUM(DelayedBedDays) * 1000.0 / SUM(Attendances), 1) AS DelayedBedDaysPer1000Attendances
FROM board_month_flow
GROUP BY Month
ORDER BY Month;
