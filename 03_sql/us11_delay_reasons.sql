-- US-11: Shows why beds are blocked: the share of delayed bed days by reason, 2019 full year versus the latest 12 months (national, adults 18+).
-- The four reasons add up exactly to "All Delay Reasons", so shares sum to 100%.
WITH latest_month AS (
    SELECT MAX(date(Month)) AS month_date FROM dd_reasons
),
r2019 AS (
    SELECT ReasonForDelay, SUM(DelayedBedDays) AS BedDays2019
    FROM dd_reasons
    WHERE date(Month) BETWEEN '2019-01-01' AND '2019-12-01'
    GROUP BY ReasonForDelay
),
rlatest AS (
    SELECT ReasonForDelay, SUM(DelayedBedDays) AS BedDaysLatest12m
    FROM dd_reasons
    WHERE date(Month) >= date((SELECT month_date FROM latest_month), '-11 months')
    GROUP BY ReasonForDelay
)
SELECT r2019.ReasonForDelay,
       BedDays2019,
       ROUND(BedDays2019 * 100.0 / (SELECT SUM(BedDays2019) FROM r2019), 1)           AS Share2019,
       BedDaysLatest12m,
       ROUND(BedDaysLatest12m * 100.0 / (SELECT SUM(BedDaysLatest12m) FROM rlatest), 1) AS ShareLatest12m,
       ROUND(BedDaysLatest12m * 1.0 / BedDays2019, 2)                                  AS Multiple
FROM r2019
JOIN rlatest USING (ReasonForDelay)
ORDER BY BedDaysLatest12m DESC;
