-- US-12: For each board, compares the change since 2019 in A&E performance (share within 4 hours) with the change in delayed bed days per 1,000 attendances.
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date FROM board_month_flow
),
base AS (
    SELECT HBName,
           SUM(Within4h) * 100.0 / SUM(Attendances)          AS Pct4h2019,
           SUM(DelayedBedDays) * 1000.0 / SUM(Attendances)   AS Delays2019
    FROM board_month_flow
    WHERE date(Month) BETWEEN '2019-01-01' AND '2019-12-01'
    GROUP BY HBName
),
latest AS (
    SELECT HBName,
           SUM(Within4h) * 100.0 / SUM(Attendances)          AS Pct4hLatest,
           SUM(DelayedBedDays) * 1000.0 / SUM(Attendances)   AS DelaysLatest
    FROM board_month_flow
    WHERE date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
    GROUP BY HBName
)
SELECT base.HBName AS HealthBoard,
       ROUND(Pct4h2019, 1)                  AS Pct4h2019,
       ROUND(Pct4hLatest, 1)                AS Pct4hLatest12m,
       ROUND(Pct4hLatest - Pct4h2019, 1)    AS Change4hPoints,
       ROUND(Delays2019, 0)                 AS DelaysPer1000Att2019,
       ROUND(DelaysLatest, 0)               AS DelaysPer1000AttLatest12m,
       ROUND(DelaysLatest - Delays2019, 0)  AS ChangeDelaysPer1000Att
FROM base
JOIN latest USING (HBName)
ORDER BY Change4hPoints;
