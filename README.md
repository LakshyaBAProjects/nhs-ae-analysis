# Scottish A&E Waiting Times: End-to-End Business Analysis

> Status: work in progress

## Problem
Scottish Emergency Departments regularly see patients wait longer than 4 hours.
Which sites and health boards are under most pressure, when does it happen, and what should operations managers do about it?

## Approach
1. **Business analysis**: problem statement, stakeholder map, BRD, user stories (`01_business/`)
2. **Data**: Public Health Scotland monthly A&E open data, cleaned with Python (`02_data/`)
3. **SQL analysis**: each query answers one user story (`03_sql/`)
4. **Power BI dashboard**: 3 pages built for operations managers (`04_dashboard/`)
5. **Recommendation memo**: findings, so-what, recommended actions (`05_findings/`)

## Key findings
_To be added._

## Dashboard
_Screenshots to be added._

## What I'd do next
_To be added._

## Data source
Public Health Scotland, Monthly A&E Activity and Waiting Times (open data, Open Government Licence).
https://www.opendata.nhs.scot/dataset/monthly-accident-and-emergency-activity-and-waiting-times

When reporting by health board, group by health board name because multiple board codes can share the same name.

## Clean the data
Install pandas for Python 3.13 with `py -3.13 -m pip install pandas`, then run `py -3.13 clean_data.py` from the project root. The script keeps only the `All` attendance category, adds health board and hospital names, labels unmatched hospitals, and converts each month to the first day of that month. It writes `02_data/clean/ae_clean.csv` and the `ae_monthly` table in `02_data/clean/ae.db`.
