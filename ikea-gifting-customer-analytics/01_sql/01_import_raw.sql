/* 01_import_raw.sql
   Create the database and load both raw sheets as text.
   Everything is loaded as VARCHAR on purpose. The raw files have mixed
   date formats and bad numeric values, and a typed import would fail or
   silently drop rows. Types are fixed in step 02.

   Load the two CSVs with the SSMS Import Flat File wizard (or BULK INSERT)
   into dbo.[Year 2009-2010] and dbo.[Year 2010-2011]. */

IF DB_ID('IKEA_Gifting') IS NULL CREATE DATABASE IKEA_Gifting;
GO
USE IKEA_Gifting;
GO

CREATE TABLE dbo.[Year 2009-2010] (
    Invoice      VARCHAR(20),
    StockCode    VARCHAR(30),
    Description  VARCHAR(255),
    Quantity     VARCHAR(20),
    InvoiceDate  VARCHAR(30),
    Price        VARCHAR(20),
    Customer_ID  VARCHAR(20),
    Country      VARCHAR(60)
);
CREATE TABLE dbo.[Year 2010-2011] (
    Invoice      VARCHAR(20),
    StockCode    VARCHAR(30),
    Description  VARCHAR(255),
    Quantity     VARCHAR(20),
    InvoiceDate  VARCHAR(30),
    Price        VARCHAR(20),
    Customer_ID  VARCHAR(20),
    Country      VARCHAR(60)
);

-- Check: the two sheets together should hold 1,067,371 rows (UCI published total)
SELECT (SELECT COUNT(*) FROM dbo.[Year 2009-2010]) +
       (SELECT COUNT(*) FROM dbo.[Year 2010-2011]) AS TotalRawRows;
