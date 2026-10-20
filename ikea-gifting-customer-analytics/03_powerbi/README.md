# 03_powerbi

- `IKEA_Project_Theme.json`: the Scandi Blue/Yellow theme. In Power BI Desktop go to View > Themes > Browse for themes.
- Put the `.pbix` file here once you add it (keep it under 100 MB for GitHub).

## How to rebuild the report
1. Run the Python step, then load `data/processed/retail_segmented.csv` (Excel or CSV) into Power BI.
2. Use a single flat table so every page shares one source, no relationships needed.
3. Add a date table fields: Month, Quarter, Year.

## DAX measures
```DAX
Total Customers = DISTINCTCOUNT(Retail[Customer_ID])
Total Revenue = SUM(Retail[Revenue])
Avg Customer Value = DIVIDE([Total Revenue], [Total Customers])
Churned % = DIVIDE(CALCULATE([Total Customers], Retail[Is_Churned] = TRUE()), [Total Customers])
```

## Pages
1. **Home**: navigation and a glossary (Recency, Frequency, Monetary, Churned %).
2. **Business Overview**: KPI cards, revenue by segment, revenue retention, revenue by month, quarter and year. Slicers for month, quarter, year, country, segment and churn status.
3. **RFM Analysis**: segment performance table, average customer value by segment, churn % by month, quarter and year.
