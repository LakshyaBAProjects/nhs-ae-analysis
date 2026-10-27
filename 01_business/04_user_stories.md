# User Stories

Format: **As a** [role], **I want** [capability], **so that** [benefit].
Each story links to a BRD requirement and to a SQL file in `03_sql/`.

| ID | User story | Acceptance criteria | BRD | SQL |
|---|---|---|---|---|
| US-01 | As an ops manager, I want to see the % of patients seen within 4 hours for my board each month, so that I can track performance. | Given a board is selected, when I view the trend, then I see a monthly % for the last 12 months. | BR-01, BR-02 | `us01_board_monthly.sql` |
| US-02 | As an executive, I want health boards ranked by 4-hour performance, so that I can see where we stand nationally. | Ranking covers the latest 12 months; all 14 boards shown; ties share a rank. | BR-03 | `us02_board_ranking.sql` |
| US-03 | As an ops manager, I want the 10 worst sites by % over 12 hours, so that I can prioritise the most serious waits. | Sites under 500 attendances are excluded; each row shows board, site, attendances and %. | BR-03 | `us03_worst_sites_12h.sql` |
| US-04 | As a clinical lead, I want to compare attendance volume with waiting performance by site, so that I can tell demand problems from flow problems. | Scatter of volume vs % within 4 hours per site; children's hospitals flagged as not directly comparable. | BR-04 | `us04_volume_vs_wait.sql` |
| US-05 | As an ops manager, I want to see which calendar months are worst, so that I can plan winter staffing. | Uses data from 2022 onwards; months ordered from lowest to highest % within 4 hours. | BR-05 | `us05_seasonality.sql` |
| US-06 | As a health board executive, I want to compare my board's current performance with its 2019 level, so that I can show how far we are from recovery. | For each board: % within 4 hours in 2019, in the latest 12 months, and the change in percentage points; sorted by largest fall. | BR-06 | `us06_baseline_2019.sql` |
| US-07 | As a clinical lead, I want to see the monthly share of patients waiting over 8 and 12 hours, so that I can tell whether the most serious waits are growing. | Monthly series from January 2019 for Scotland; both measures shown; chart marks February 2025. | BR-07 | `us07_long_waits_trend.sql` |
| US-08 | As a data analyst, I want to see which sites are excluded or unnamed in the rankings, so that I can explain the limits of the analysis to stakeholders. | Every Type 1 site listed with attendances and a status: included, excluded (under 500), or name not in lookup. | BR-08 | `us08_data_coverage.sql` |
