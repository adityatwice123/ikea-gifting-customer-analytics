/* 03_deduplicate_and_clean.sql
   1. Remove exact duplicate rows with ROW_NUMBER().
   2. Drop rows that cannot be used for customer analysis.
   Result: dbo.RetailCleaned, the table exported to CSV for Python. */
USE IKEA_Gifting;
GO

WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Invoice, StockCode, Description, Quantity,
                            InvoiceDate, Price, Customer_ID, Country
               ORDER BY (SELECT NULL)) AS rn
    FROM dbo.RetailCombined
)
SELECT Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country
INTO dbo.RetailDeduped
FROM ranked
WHERE rn = 1;

-- Exploratory checks on what is about to be removed
SELECT COUNT(*) AS RowsAfterDedup FROM dbo.RetailDeduped;           -- expect 1,033,036
SELECT COUNT(*) AS NoCustomerId  FROM dbo.RetailDeduped WHERE Customer_ID IS NULL;
SELECT COUNT(*) AS Cancellations FROM dbo.RetailDeduped WHERE Invoice LIKE 'C%';
SELECT COUNT(*) AS Adjustments   FROM dbo.RetailDeduped WHERE Invoice LIKE 'A%';
SELECT COUNT(*) AS NonPositiveQty FROM dbo.RetailDeduped WHERE Quantity <= 0;

SELECT *
INTO dbo.RetailCleaned
FROM dbo.RetailDeduped
WHERE Customer_ID IS NOT NULL      -- cannot score an unknown customer
  AND Invoice NOT LIKE 'C%'        -- cancellations
  AND Invoice NOT LIKE 'A%'        -- bad debt adjustments
  AND Quantity > 0;

-- Final validation
SELECT COUNT(*) AS CleanRows,                   -- expect 779,495
       COUNT(DISTINCT Customer_ID) AS Customers, -- expect 5,881
       SUM(Quantity * Price) AS TotalRevenue     -- expect about 17.37M
FROM dbo.RetailCleaned;
