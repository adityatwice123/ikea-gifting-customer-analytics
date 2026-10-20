"""Pandas version of the SQL cleaning step (01_sql), so the project can be
reproduced without SQL Server. Gives the same result as 01_sql/03_clean_final.sql.
"""
import pandas as pd

RAW = ["data/raw/online_retail_II page 1.csv", "data/raw/online_retail_II page 2.csv"]

df = pd.concat([pd.read_csv(f, dtype=str, encoding="latin-1") for f in RAW], ignore_index=True)
print("raw rows:", f"{len(df):,}")

df = df.drop_duplicates()
print("after exact duplicates removed:", f"{len(df):,}")

df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"], format="%d-%m-%Y %H:%M")
df["Quantity"] = pd.to_numeric(df["Quantity"])
df["Price"] = pd.to_numeric(df["Price"])
df = df.rename(columns={"Customer ID": "Customer_ID"})

df = df[df["Customer_ID"].notna()]                     # no customer id, cannot be scored
df = df[~df["Invoice"].str.startswith(("C", "A"))]     # cancellations and adjustments
df = df[df["Quantity"] > 0]
df["Customer_ID"] = df["Customer_ID"].astype(float).astype(int)

print("clean rows:", f"{len(df):,}", "  customers:", f"{df['Customer_ID'].nunique():,}")
df.to_csv("data/processed/retail_cleaned.csv", index=False)
