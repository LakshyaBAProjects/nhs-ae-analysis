"""
Phase 2: add delayed-discharge data and link it to the A&E data.

What this script does (plain English):
1. Reads the two Public Health Scotland delayed-discharge files (bed days + monthly census).
2. Keeps only the rows that avoid double counting:
   - AgeGroup == "18plus"           (18-74 + 75plus are already inside it)
   - ReasonForDelay == "All Delay Reasons"  (the other reasons are already inside it)
   - removes the Scotland total (S92000003) so it can't be added on top of the 14 boards
3. Adds health board names, saves table `dd_monthly` in ae.db.
4. Saves table `dd_reasons` (same filters, but split by reason) to show WHY beds are blocked.
5. Builds `board_month_flow`: one row per board per month with the A&E result and delayed beds side by side.
"""
from pathlib import Path
import shutil
import sqlite3
import tempfile

import pandas as pd

from clean_data import require_unique_names

ROOT = Path(__file__).resolve().parent
RAW_DIR = ROOT / "02_data" / "raw"
CLEAN_DIR = ROOT / "02_data" / "clean"

BEDDAYS_FILE = RAW_DIR / "2026-08_delayed-discharge-beddays-health-board.csv"
CENSUS_FILE = RAW_DIR / "2026-06_delayed-discharge-census-health-board.csv"
HEALTH_BOARD_FILE = RAW_DIR / "652ff726-e676-4a20-abda-435b98dd7bdc.csv"
DATABASE_FILE = CLEAN_DIR / "ae.db"
SCOTLAND_CODE = "S92000003"


def load(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path, dtype={"MonthOfDelay": "string", "HBT": "string"})
    df = df.loc[df["AgeGroup"].eq("18plus") & df["HBT"].ne(SCOTLAND_CODE)].copy()
    df["Month"] = pd.to_datetime(df["MonthOfDelay"], format="%Y%m", errors="raise").dt.date
    return df


def main() -> None:
    boards = pd.read_csv(HEALTH_BOARD_FILE, dtype={"HB": "string", "HBName": "string"})
    boards = require_unique_names(boards, "HB", "HBName")

    beddays = load(BEDDAYS_FILE)
    census = load(CENSUS_FILE)

    # --- monthly totals per board (All Delay Reasons only) ---
    bd_all = beddays.loc[beddays["ReasonForDelay"].eq("All Delay Reasons"),
                         ["Month", "HBT", "NumberOfDelayedBedDays", "AverageDailyNumberOfDelayedBeds"]]
    ce_all = census.loc[census["ReasonForDelay"].eq("All Delay Reasons"),
                        ["Month", "HBT", "NumberOfCensusDelays"]]
    dd = bd_all.merge(ce_all, on=["Month", "HBT"], how="left", validate="one_to_one")
    dd = dd.merge(boards, left_on="HBT", right_on="HB", how="left", validate="many_to_one").drop(columns="HB")
    if dd["HBName"].isna().any():
        raise ValueError("Some delayed-discharge board codes have no name in the lookup")
    dd = dd.rename(columns={
        "NumberOfDelayedBedDays": "DelayedBedDays",
        "AverageDailyNumberOfDelayedBeds": "AvgDailyDelayedBeds",
        "NumberOfCensusDelays": "CensusDelays",
    })

    # --- split by reason (excludes the 'All' row so reasons add up exactly) ---
    reasons = beddays.loc[~beddays["ReasonForDelay"].eq("All Delay Reasons"),
                          ["Month", "HBT", "ReasonForDelay", "NumberOfDelayedBedDays"]]
    reasons = reasons.merge(boards, left_on="HBT", right_on="HB", how="left").drop(columns="HB")
    reasons = reasons.rename(columns={"NumberOfDelayedBedDays": "DelayedBedDays"})

    # Work on a temporary copy of the database, then copy it back. This avoids
    # file-locking problems on synced or network drives.
    tmp_dir = Path(tempfile.mkdtemp())
    work_db = tmp_dir / "ae.db"
    shutil.copy2(DATABASE_FILE, work_db)
    with sqlite3.connect(work_db) as con:
        dd.to_sql("dd_monthly", con, if_exists="replace", index=False)
        reasons.to_sql("dd_reasons", con, if_exists="replace", index=False)
        con.executescript("""
            DROP TABLE IF EXISTS board_month_flow;
            CREATE TABLE board_month_flow AS
            SELECT a.Month,
                   a.HBName,
                   a.Attendances,
                   a.Within4h,
                   ROUND(a.Within4h * 100.0 / a.Attendances, 1)         AS PctWithin4h,
                   a.Over12h,
                   ROUND(a.Over12h * 100.0 / a.Attendances, 2)          AS PctOver12h,
                   d.DelayedBedDays,
                   d.AvgDailyDelayedBeds,
                   d.CensusDelays,
                   ROUND(d.DelayedBedDays * 1000.0 / a.Attendances, 1)  AS DelayedBedDaysPer1000Att
            FROM (
                SELECT Month, HBName,
                       SUM(NumberOfAttendancesEpisode) AS Attendances,
                       SUM(NumberWithin4HoursEpisode)  AS Within4h,
                       SUM(NumberOver12HoursEpisode)   AS Over12h
                FROM ae_monthly
                WHERE DepartmentType = 'Type 1' AND HBName IS NOT NULL
                GROUP BY Month, HBName
                HAVING SUM(NumberOfAttendancesEpisode) > 0
            ) a
            JOIN (
                SELECT Month, HBName,
                       SUM(DelayedBedDays) AS DelayedBedDays,
                       SUM(AvgDailyDelayedBeds) AS AvgDailyDelayedBeds,
                       SUM(CensusDelays) AS CensusDelays
                FROM dd_monthly GROUP BY Month, HBName
            ) d ON d.Month = a.Month AND d.HBName = a.HBName;
        """)
        n = con.execute("SELECT COUNT(*), MIN(Month), MAX(Month) FROM board_month_flow").fetchone()
    con.close()
    shutil.copy2(work_db, DATABASE_FILE)
    shutil.rmtree(tmp_dir, ignore_errors=True)

    dd.to_csv(CLEAN_DIR / "dd_monthly.csv", index=False)
    with sqlite3.connect(DATABASE_FILE) as con:
        pd.read_sql("SELECT * FROM board_month_flow", con).to_csv(CLEAN_DIR / "board_month_flow.csv", index=False)
    reasons.to_csv(CLEAN_DIR / "dd_reasons.csv", index=False)
    print(f"dd_monthly: {len(dd):,} rows | dd_reasons: {len(reasons):,} rows")
    print(f"board_month_flow: {n[0]:,} rows, {n[1]} to {n[2]}")


if __name__ == "__main__":
    main()
