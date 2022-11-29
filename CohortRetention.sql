/****** Script for SelectTopNRows command from SSMS  ******/
SELECT[InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [PortfolioProject].[dbo].['Online Retail$']

  --checking data type
  SELECT 
TABLE_CATALOG,
TABLE_SCHEMA,
TABLE_NAME, 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
--- Converting invoiceDate to only date

SELECT CAST(InvoiceDate AS DATE) AS Invoice_Date
 FROM [PortfolioProject].[dbo].['Online Retail$']
 -- Changing data type
 ALTER TABLE [PortfolioProject].[dbo].['Online Retail$']
 ALTER COLUMN CustomerID int;

  ALTER TABLE [PortfolioProject].[dbo].['Online Retail$']
 ALTER COLUMN InvoiceNo int;

 ALTER TABLE [PortfolioProject].[dbo].['Online Retail$']
 ALTER COLUMN InvoiceDate Date;


 -- total records 

 SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [PortfolioProject].[dbo].['Online Retail$']
  WHERE CustomerID is NULL -- 135,080 Ccustomers do not have an id

  -- lets drop rows where customers dont have ID 
  DELETE FROM [PortfolioProject].[dbo].['Online Retail$']
  WHERE CustomerID is NULL; -- deleted 135,080 rows

  -- checking for null invoice 
  SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [PortfolioProject].[dbo].['Online Retail$']
  WHERE InvoiceNo is NULL -- 8905 rows have no invoice number

  -- lets drop rows where no invoice number
  DELETE FROM [PortfolioProject].[dbo].['Online Retail$']
  WHERE InvoiceNo is NULL; -- deleted 135,080 rows
 
 -- checking for values with with quanity and unit price
 ;with online_retail as
 (
 SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [PortfolioProject].[dbo].['Online Retail$']
)
, quantity_unit_price AS
(
SELECT *
FROM online_retail
WHERE Quantity > 0 and UnitPrice > 0
-- we wil be working with  397884 rows
)

--SELECT * FROM quantity_unit_price
, dup_check as
(
--SELECT * FROM quantity_unit_price
--Chceking for duplicates
SELECT *, ROW_NUMBER() OVER (PARTITION BY InvoiceNo, StockCode, Quantity order by InvoiceDate) AS dup_flag
FROM quantity_unit_price

)
--SELECT * FROM dup_check

--SELECT * FROM dup_check
--where dup_flag > 1 -- i have 5215 duplicate rows

-- creating a temp tale for cleaned data
SELECT *
INTO #online_retail_main
FROM dup_check
WHERE dup_flag = 1 
--Temp table created for cleaned data
-- begin cohort analysis
SELECT * FROM 
#online_retail_main

--Unique Identifier(customerID)
-- initial start date(first invoice date)
--Revenu data

SELECT CustomerID,
	   min(InvoiceDate) AS first_purchase_date,
	   DATEFROMPARTS(year(min(InvoiceDate)), month(min(InvoiceDate)),1) as Cohort_Date -- using one here counts the customer first purchase as firstof the month
INTO #cohort -- creating temp table for cohort
FROM 
#online_retail_main
GROUP BY CustomerID

SELECT *
FROM #cohort

-- Creating Cohort Index
SELECT 
  mmm.*,
  cohort_index = year_diff * 12 + month_diff + 1
INTO #cohort_retention
  FROM
(SELECT 
	mm.*,
	year_diff = invoice_year - cohort_year,
	month_diff = invoice_month - cohort_month
FROM
(SELECT
	m.*,
	c.Cohort_Date,
	YEAR(m.InvoiceDate) invoice_year, -- briging out the year of invoice
	MONTH(m.InvoiceDate) invoice_month, -- bringing out the month of invoice
	YEAR(c.Cohort_Date) cohort_year,  --- bringing out the year of cohort
	MONTH(c.Cohort_date) cohort_month --- bringing out the month of cohort
 
FROM #online_retail_main m
LEFT JOIN #cohort c
	ON m.CustomerID = c.CustomerID
	) mm

) mmm

SELECT * 
FROM 
#cohort_retention

-- distinct cutsomer details
SELECT distinct 
       CustomerID,
	   Cohort_Date,
	   Cohort_index
FROM #cohort_retention
ORDER BY 1,3

---Pivot Data to see the cohort table
select 	*
into #cohort_pivot
from(
	select distinct 
		CustomerID,
		Cohort_Date,
		cohort_index
	from #cohort_retention
)tbl
pivot(
	Count(CustomerID)
	for Cohort_Index In 
		(
		[1], 
        [2], 
        [3], 
        [4], 
        [5], 
        [6], 
        [7],
		[8], 
        [9], 
        [10], 
        [11], 
        [12],
		[13])

)as pivot_table

SELECT * FROM #cohort_pivot
ORDER BY 1

select *
from #cohort_pivot
order by Cohort_Date

select Cohort_Date ,
	(1.0 * [1]/[1] * 100) as [1], 
    1.0 * [2]/[1] * 100 as [2], 
    1.0 * [3]/[1] * 100 as [3],  
    1.0 * [4]/[1] * 100 as [4],  
    1.0 * [5]/[1] * 100 as [5], 
    1.0 * [6]/[1] * 100 as [6], 
    1.0 * [7]/[1] * 100 as [7], 
	1.0 * [8]/[1] * 100 as [8], 
    1.0 * [9]/[1] * 100 as [9], 
    1.0 * [10]/[1] * 100 as [10],   
    1.0 * [11]/[1] * 100 as [11],  
    1.0 * [12]/[1] * 100 as [12],  
	1.0 * [13]/[1] * 100 as [13]
from #cohort_pivot
order by Cohort_Date
