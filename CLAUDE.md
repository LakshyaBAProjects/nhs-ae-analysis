# Notes for Claude Code

- Owner is a business analyst, beginner at coding. Explain what each script does in plain English before running it.
- Use Python 3.13 (`py -3.13`). Windows machine, PowerShell.
- Prefer pandas + sqlite3 (standard library). Keep scripts short and commented.
- Never edit files in `02_data/raw/`. Write cleaned outputs to `02_data/clean/`.
- SQLite database lives at `02_data/clean/ae.db`.
- Each `.sql` file in `03_sql/` starts with a comment naming the user story it answers (e.g. `-- US-03`).
- Data trap: the attendance category has New Planned, Unplanned and All. "All" = the sum of the other two. Never add them together (double counting).
- Monthly data covers A&E services and is the appropriate PHS dataset for monitoring the official 4-hour standard. Say "share of patients waiting over 4 hours", not "breach of target".
- Some health boards have multiple codes with the same name. When aggregating, group by health board name, not code.
