/* 02_fix_types_and_combine.sql
   Convert text columns to proper types and stack both sheets into one table.
   Dates: some rows are yyyy-mm-dd hh:mi:ss (style 120), others dd-mm-yyyy hh:mi
   (style 105). COALESCE tries one, then the other. */
USE IKEA_Gifting;
GO

SELECT
    Invoice, StockCode, Description,
    TRY_CONVERT(int, Quantity) AS Quantity,
    COALESCE(TRY_CONVERT(datetime2, InvoiceDate, 120),
             TRY_CONVERT(datetime2, InvoiceDate, 105)) AS InvoiceDate,
    TRY_CONVERT(decimal(10,2), Price) AS Price,
    TRY_CONVERT(int, TRY_CONVERT(decimal(12,1), Customer_ID)) AS Customer_ID,
    Country
INTO dbo.RetailCombined
FROM (
    SELECT * FROM dbo.[Year 2009-2010]
    UNION ALL
    SELECT * FROM dbo.[Year 2010-2011]
) AS raw_rows;

-- Checks: row count must still be 1,067,371 and no date should have failed to parse
SELECT COUNT(*) AS Rows_, SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS BadDates
FROM dbo.RetailCombined;
