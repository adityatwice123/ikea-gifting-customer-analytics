# 02_python

1. `clean_data.py` (only if you skipped SQL) builds `data/processed/retail_cleaned.csv` from the raw CSVs.
2. `rfm_segmentation.py` (or the notebook of the same name) scores customers and writes
   `customer_segments.csv` and `retail_segmented.csv` to `data/processed/`.

Run both from the repo root: `python 02_python/clean_data.py` then `python 02_python/rfm_segmentation.py`.

## Scoring
- Recency, days since last purchase, scored 5 (most recent) to 1
- Frequency, distinct invoices, scored 1 to 5
- Monetary, total spend, scored 1 to 5
- Churned = no purchase in the 90 days before the last date in the data

## Segment rules
| Segment | Rule |
|---|---|
| Champions | R, F and M all 4 or 5 |
| At Risk | R 1 or 2, F 3 or more |
| Lost | R 1 or 2, F 1 or 2 |
| New | R 4 or 5, F 1 or 2 |
| Needs Attention | R 3, F 1 or 2 |
| Loyal | Everything else (R 3 or more, F 3 or more, not Champions) |
