"""RFM segmentation and 90 day churn flag.

Input : data/processed/retail_cleaned.csv  (output of 01_sql, or of clean_data.py)
Output: data/processed/customer_segments.csv  (one row per customer)
        data/processed/retail_segmented.csv   (transactions + segment, for Power BI)
"""
import pandas as pd

CHURN_DAYS = 90

tx = pd.read_csv("data/processed/retail_cleaned.csv", parse_dates=["InvoiceDate"])
tx["Revenue"] = tx["Quantity"] * tx["Price"]

# snapshot = day after the last transaction in the data
snapshot = tx["InvoiceDate"].max().normalize() + pd.Timedelta(days=1)

rfm = tx.groupby("Customer_ID").agg(
    LastPurchase=("InvoiceDate", "max"),
    Frequency=("Invoice", "nunique"),
    Monetary=("Revenue", "sum"),
).reset_index()
rfm["Recency"] = (snapshot - rfm["LastPurchase"]).dt.days

rfm["R_Score"] = pd.qcut(rfm["Recency"], 5, labels=[5, 4, 3, 2, 1]).astype(int)
rfm["F_Score"] = pd.qcut(rfm["Frequency"].rank(method="first"), 5, labels=[1, 2, 3, 4, 5]).astype(int)
rfm["M_Score"] = pd.qcut(rfm["Monetary"], 5, labels=[1, 2, 3, 4, 5]).astype(int)


def segment(r):
    R, F, M = r.R_Score, r.F_Score, r.M_Score
    if R >= 4 and F >= 4 and M >= 4:
        return "Champions"      # recent, frequent, high spend
    if R <= 2:
        return "At Risk" if F >= 3 else "Lost"   # gone quiet: valuable before vs never engaged
    if R >= 4 and F <= 2:
        return "New"            # recent but not yet repeat buyers
    if F <= 2:
        return "Needs Attention"  # middling recency, low frequency
    return "Loyal"              # steady repeat buyers, not top tier


rfm["Segment"] = rfm.apply(segment, axis=1)
rfm["Is_Churned"] = rfm["Recency"] > CHURN_DAYS

rfm.to_csv("data/processed/customer_segments.csv", index=False)
tx.merge(rfm[["Customer_ID", "Segment", "Is_Churned", "R_Score", "F_Score", "M_Score"]],
         on="Customer_ID").to_csv("data/processed/retail_segmented.csv", index=False)

print(f"Customers: {len(rfm):,}   Revenue: {tx['Revenue'].sum():,.0f}   "
      f"Churned: {rfm['Is_Churned'].mean():.2%}")
print(rfm.groupby("Segment").agg(Customers=("Customer_ID", "count"),
                                 Revenue=("Monetary", "sum"),
                                 AvgValue=("Monetary", "mean")).round(0))
