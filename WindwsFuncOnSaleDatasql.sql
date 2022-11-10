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
  
  
![windowfunccon](https://user-images.githubusercontent.com/106359949/200994599-db4a01d9-3f0c-426a-8530-80dc42f156fd.JPG)
![windwsfunoutput](https://user-images.githubusercontent.com/106359949/200994601-42b9bb03-38ed-4a23-8b88-c547bc2771aa.JPG)
