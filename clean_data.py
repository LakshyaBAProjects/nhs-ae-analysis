from pathlib import Path
import sqlite3

import pandas as pd


ROOT = Path(__file__).resolve().parent
RAW_DIR = ROOT / "02_data" / "raw"
CLEAN_DIR = ROOT / "02_data" / "clean"

AE_FILE = RAW_DIR / "37ba17b1-c323-492c-87d5-e986aae9ab59.csv"
HEALTH_BOARD_FILE = RAW_DIR / "652ff726-e676-4a20-abda-435b98dd7bdc.csv"
HOSPITAL_FILE = RAW_DIR / "hospitals.csv"
OUTPUT_CSV = CLEAN_DIR / "ae_clean.csv"
DATABASE_FILE = CLEAN_DIR / "ae.db"


def require_unique_names(lookup: pd.DataFrame, code_column: str, name_column: str) -> pd.DataFrame:
    lookup = lookup[[code_column, name_column]].dropna(subset=[code_column, name_column]).drop_duplicates()
    conflicting_codes = lookup.loc[lookup.duplicated(code_column, keep=False), code_column].unique()
    if len(conflicting_codes):
        codes = ", ".join(str(code) for code in conflicting_codes[:10])
        raise ValueError(f"Lookup codes have multiple names ({code_column}): {codes}")
    return lookup


def main() -> None:
    CLEAN_DIR.mkdir(parents=True, exist_ok=True)

    ae = pd.read_csv(
        AE_FILE,
        dtype={
            "_id": "string",
            "Month": "string",
            "Country": "string",
            "HBT": "string",
            "TreatmentLocation": "string",
            "DepartmentType": "string",
            "AttendanceCategory": "string",
        },
    )
    health_boards = pd.read_csv(HEALTH_BOARD_FILE, dtype={"HB": "string", "HBName": "string"})
    hospitals = pd.read_csv(HOSPITAL_FILE, dtype={"HospitalCode": "string", "HospitalName": "string"})

    # Keep the combined category only so planned and unplanned attendances are not double-counted.
    ae = ae.loc[ae["AttendanceCategory"].eq("All")].copy()

    ae["Month"] = pd.to_datetime(ae["Month"], format="%Y%m", errors="raise").dt.date

    health_boards = require_unique_names(health_boards, "HB", "HBName")
    hospitals = require_unique_names(hospitals, "HospitalCode", "HospitalName")

    ae = ae.merge(
        health_boards,
        left_on="HBT",
        right_on="HB",
        how="left",
        validate="many_to_one",
    ).drop(columns="HB")
    ae = ae.merge(
        hospitals,
        left_on="TreatmentLocation",
        right_on="HospitalCode",
        how="left",
        validate="many_to_one",
    ).drop(columns="HospitalCode")

    missing_site = ae["HospitalName"].isna()
    ae.loc[missing_site, "HospitalName"] = (
        "Unknown site (" + ae.loc[missing_site, "TreatmentLocation"].fillna("unknown code") + ")"
    )

    ae.to_csv(OUTPUT_CSV, index=False)
    with sqlite3.connect(DATABASE_FILE) as connection:
        ae.to_sql("ae_monthly", connection, if_exists="replace", index=False)

    print(f"Saved {len(ae):,} rows to {OUTPUT_CSV}")
    print(f"Loaded table 'ae_monthly' into {DATABASE_FILE}")


if __name__ == "__main__":
    main()