# Business Requirements Document (BRD)

| Item | Detail |
|---|---|
| Project | Scottish A&E Waiting Times Analysis |
| Author | Kumar Lakshya |
| Version | 0.2 (draft) |
| Date | 25 October 2026 |

## 1. Objective
Give health board operations managers a clear, comparable view of A&E waiting-time performance, so they can target improvement where it matters most.

## 2. Background
Public Health Scotland publishes monthly A&E activity and waiting-time data for every hospital in Scotland. Across Type 1 Emergency Departments, the share of patients seen within 4 hours fell from about 87% in 2019 to about 63% over the latest 12 months, and long waits have grown (over 12 hours: about 0.4% in January 2019, about 5% in August 2026). Boards differ widely: in the latest 12 months Orkney and Western Isles are above 90%, while Forth Valley, Lanarkshire and Grampian are between 47% and 55%.

## 3. Scope
**In scope:**
- Type 1 Emergency Departments, all 14 health boards, all sites with a name in the PHS hospital list
- Monthly data from 2019 to the latest month (earlier years used only for context)
- KPIs: % within 4 hours, % over 8 hours, % over 12 hours, attendances
- SQL analysis, Power BI dashboard (3 pages), one-page recommendation memo

**Out of scope:**
- Minor injury units and other Type 3 services (no 8/12-hour data)
- Patient-level data, staffing, bed capacity, clinical outcomes
- Forecasting and real-time monitoring
- Official performance reporting (PHS publishes that)

## 4. Business requirements
| ID | Requirement | Priority (MoSCoW) |
|---|---|---|
| BR-01 | Show share of patients seen within 4 hours by health board and site | Must |
| BR-02 | Show monthly trend over at least 12 months | Must |
| BR-03 | Rank boards and sites by 4-hour, 8-hour and 12-hour waits | Must |
| BR-04 | Compare attendance volume against waiting performance | Should |
| BR-05 | Highlight seasonal patterns (from 2022 onwards) | Should |
| BR-06 | Compare each board with its 2019 baseline | Should |
| BR-07 | Show the trend in 8-hour and 12-hour waits | Should |
| BR-08 | Show which sites are excluded or unnamed in the rankings | Should |
| BR-09 | Export a one-page summary | Could |
| BR-10 | Real-time data | Won't (source data is monthly) |

## 5. KPIs
| KPI | Definition |
|---|---|
| % within 4 hours | Episodes within 4 hours ÷ total episodes (Type 1) |
| % over 8 hours | Episodes over 8 hours ÷ total episodes (Type 1) |
| % over 12 hours | Episodes over 12 hours ÷ total episodes (Type 1) |
| Monthly attendances | Total episodes (Type 1), using the "All" category only |

Percentages are calculated from summed counts, never by averaging site percentages.

## 6. Assumptions and constraints
- The "All" attendance category equals Unplanned plus New planned. Only "All" is used, to avoid double counting.
- The 8-hour and 12-hour figures exist only for Type 1 Emergency Departments, so the analysis is Type 1 only.
- Rankings exclude sites with fewer than 500 attendances in the period, because small numbers swing percentages.
- 15 site codes in the A&E data have no name in the PHS hospital list (likely closed or renamed). They are shown as "Unknown site (code)" and are not dropped.
- Planned attendances were added to the 4-hour standard in February 2025, so trends crossing that date are not perfectly like-for-like.
- Results describe patterns in published data. They are not an official compliance statement.

## 7. Risks
| Risk | Impact | Mitigation |
|---|---|---|
| Definition change in Feb 2025 | Trend break | Mark the date on trend charts |
| Small sites give volatile percentages | Misleading rankings | 500-attendance minimum, shown in the data coverage view |
| Sites differ in case mix (e.g. children's hospitals) | Unfair comparison | Flag them in the volume-vs-wait view |
| Unnamed sites in the lookup | Gaps in site view | Show as "Unknown site" and report the count |
| Long history masks recent patterns | Wrong planning conclusions | Seasonality uses 2022 onwards |

## 8. Sign-off
| Role | Name | Date |
|---|---|---|
| Business analyst (author) | Kumar Lakshya | 25 October 2026 |
| Sponsor (simulated) | Head of Operations, a health board | _Pending_ |
