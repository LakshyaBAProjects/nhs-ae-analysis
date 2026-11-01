# Recommendation Memo: Scottish A&E Waiting Times

**To:** Head of Operations, [health board] (simulated sponsor)
**From:** Kumar Lakshya, Business Analyst
**Date:** 1 November 2026 (updated with Phase 2)
**Data:** Public Health Scotland monthly A&E data, Type 1 Emergency Departments, to August 2026

## Summary
Four-hour performance in Scotland's Emergency Departments has fallen from about **87% in 2019 to 63% over the latest 12 months**, and waits over 12 hours have risen from **0.4% to 6.0%** of patients. The decline is not evenly spread. Five boards account for most of the weakest sites, and one comparison suggests the problem is patient flow rather than demand. Delayed discharges (blocked beds) have also grown by about a third since 2019, but they do not explain which boards perform worst. I recommend targeting improvement support at a short list of sites, learning from the best-performing large site, and tracking 12-hour waits as a headline measure.

## What the data shows
| # | Finding | Evidence |
|---|---|---|
| 1 | Performance has fallen sharply since 2019 | 87.4% (2019) to 63.2% (Sep 2025 to Aug 2026) |
| 2 | Long waits have grown | Over 12 hours: 0.4% (Jan 2019) to 6.0% (latest 12 months), peaking in winter |
| 3 | Boards differ widely | Orkney 93.4% and Western Isles 91.9%, against Grampian 54.7%, Lanarkshire 52.0% and Forth Valley 46.9% |
| 4 | The biggest falls are in the weakest boards | Since 2019: Forth Valley -39 points, Grampian -36, Lanarkshire -34. Orkney only -3 |
| 5 | Longest waits are concentrated | Wishaw (13.9% over 12 hours), Ayr (12.5%) and Hairmyres (11.6%) top the list. Lanarkshire has three of the worst ten sites |
| 6 | Demand does not explain the gap | Ninewells (Tayside) and Forth Valley Royal handle about 65,000 attendances each. Ninewells sees about 86% within 4 hours, Forth Valley Royal 47% |
| 7 | Winter is the weakest period | Since 2022, December averages 61.1% within 4 hours, against 67.4% in May |

## So what
- Similar volumes with very different results point to **how patients move through the hospital** (admission, bed availability, discharge), not simply how many arrive. This is a hypothesis: the data does not include bed capacity or staffing. Delayed-discharge data was tested in Phase 2 (below) and does not explain the gap between boards.
- Improvement effort spread evenly across all sites would be diluted. A small number of sites hold the longest waits.
- The 4-hour measure alone hides the most serious waits. The share waiting over 12 hours has grown faster, in relative terms.

## Phase 2: do delayed discharges explain it?
| # | Finding | Evidence |
|---|---|---|
| 8 | Blocked beds have grown by about a third | Average daily delayed beds: about 1,455 (2019) to 1,958 (latest 12 months); bed days 530,886 to 714,462 |
| 9 | The pressure is structural, not seasonal | National level runs from about 1,835 (Apr to Jun) to about 1,960 (Nov) |
| 10 | Delays do not explain the gap between boards | Lanarkshire has the lowest delayed-bed rate (296 per 1,000 attendances) yet 52.0% within 4 hours. Western Isles has the highest (1,564) yet 91.9% |
| 11 | Delays for adults with incapacity have doubled | Code 9 AWI: 73,609 to 147,828 bed days; 13.9% to 20.7% of delayed bed days |

Scope: 14 boards, adults 18+ for delays, Type 1 EDs for A&E. With 14 boards, correlations are indicative only. Detail: `05_findings/phase2_delayed_discharge_findings.md`.

## Recommendations
1. **Prioritise a short list of sites for support:** Wishaw, Hairmyres, Monklands (Lanarkshire), Forth Valley Royal, Aberdeen Royal Infirmary, and Ayr and Crosshouse (Ayrshire and Arran). These combine low 4-hour performance with high 12-hour waits.
2. **Run a peer review with Tayside.** Compare patient-flow practice at Ninewells with Forth Valley Royal and Wishaw (admission pathways, bed management, discharge timing) to test whether flow explains the gap.
3. **Bring winter planning forward.** Performance falls from October and is lowest in December. Staffing and bed plans should be in place by September.
4. **Report 12-hour waits alongside the 4-hour measure** in routine board reporting.
5. **Add data to test the causes:** total bed capacity, occupancy and staffing by site. Delayed discharge has been tested and does not explain the board gap, so these are the next layers.
6. **Treat delayed discharge as a national workstream.** About 500 more beds a day are blocked than in 2019, and delays for adults with incapacity have doubled. This will not close the A&E gap on its own in the worst boards.

## Indicative impact (illustrative arithmetic, not a forecast)
- A 10-point improvement at Forth Valley Royal (about 65,750 attendances a year) would mean roughly **6,600 more patients seen within 4 hours** each year.
- Cutting 12-hour waits at Wishaw by a quarter (about 9,900 patients waited over 12 hours in the latest 12 months) would mean roughly **2,500 fewer** such waits a year.

## Limitations
- Aggregated published data: it shows where and when, not why.
- Type 1 Emergency Departments only. Minor injury units have no 8- or 12-hour data.
- Planned attendances joined the 4-hour standard in February 2025, so trends across that date are not perfectly like-for-like.
- Children's hospitals (Glasgow, Edinburgh, Aberdeen) are not directly comparable with general Emergency Departments.
- 15 site codes have no name in the PHS hospital list and are labelled "Unknown site". Sites under 500 attendances are excluded from rankings.
- Delay figures cover adults aged 18+ and are by health board, not by hospital site. Delayed bed days are scaled by Type 1 attendances rather than population, so small boards are noisy.
- Seasonality uses January 2022 onwards, because the earlier years differ too much to compare.

## Next steps
1. Agree the priority site list with operations managers and clinical leads.
2. Request total bed capacity, occupancy and staffing data for those sites.
3. Repeat this analysis quarterly using the same dashboard.

*Supporting material: Power BI dashboard (`04_dashboard`), SQL queries (`03_sql`), BRD and user stories (`01_business`).*
