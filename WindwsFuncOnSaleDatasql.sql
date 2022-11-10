/****** Script for SelectTopNRows command from SSMS  ******/
-- windows functions to rank customer according to number of orders on their name

WITH Cust_m AS (
SELECT 
  CUSTOMERNAME,
  COUNT(CUSTOMERNAME) AS Customer_amount
  FROM [PortfolioProject].[dbo].[sales_data_sample]
  GROUP BY CUSTOMERNAME)

  SELECT 
  CUSTOMERNAME,
  MAX(Customer_amount)
  from Cust_m 
  GROUP BY CUSTOMERNAME
  ORDER BY 2 DESC

  --Checking to compare numbers is correct


WITH Customer_name AS (
SELECT 

CUSTOMERNAME,
COUNT(*) AS Customer_amount
  FROM [PortfolioProject].[dbo].[sales_data_sample]
  GROUP BY CUSTOMERNAME)

  SELECT

  CUSTOMERNAME,
  ROW_NUMBER() OVER (ORDER BY Customer_amount DESC) AS Customer_Rank
  FROM Customer_name
  ORDER BY Customer_amount DESC;

  -- number match, correct