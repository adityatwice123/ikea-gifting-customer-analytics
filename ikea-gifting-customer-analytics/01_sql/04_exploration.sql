/* 04_exploration.sql  Sanity checks and first look at the cleaned data. */
USE IKEA_Gifting;
GO

-- Revenue by country
SELECT TOP 10 Country, COUNT(DISTINCT Customer_ID) AS Customers,
       SUM(Quantity * Price) AS Revenue
FROM dbo.RetailCleaned GROUP BY Country ORDER BY Revenue DESC;

-- Revenue by month (shows the Q4 gifting peak)
SELECT YEAR(InvoiceDate) AS Yr, MONTH(InvoiceDate) AS Mth, SUM(Quantity * Price) AS Revenue
FROM dbo.RetailCleaned GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate) ORDER BY Yr, Mth;

-- Top 20 customers by revenue
SELECT TOP 20 Customer_ID, COUNT(DISTINCT Invoice) AS Orders, SUM(Quantity * Price) AS Revenue
FROM dbo.RetailCleaned GROUP BY Customer_ID ORDER BY Revenue DESC;

-- Date range
SELECT MIN(InvoiceDate) AS FirstOrder, MAX(InvoiceDate) AS LastOrder FROM dbo.RetailCleaned;
