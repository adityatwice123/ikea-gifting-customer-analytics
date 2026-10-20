# 01_sql

Run the scripts in order in SQL Server Management Studio.

| Script | What it does |
|---|---|
| 01_import_raw.sql | Creates the database and raw tables (all text) |
| 02_fix_types_and_combine.sql | Fixes data types and mixed date formats, stacks the two sheets |
| 03_deduplicate_and_clean.sql | Removes duplicates and unusable rows, creates `RetailCleaned` |
| 04_exploration.sql | Quick checks by country, month and top customers |

Export `dbo.RetailCleaned` to `data/processed/retail_cleaned.csv` when done.
No SQL Server? `02_python/clean_data.py` does the same cleaning in pandas.
