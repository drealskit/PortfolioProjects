/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[Year_Birth]
      ,[Education]
      ,[Marital_Status]
      ,[Income]
      ,[Kidhome]
      ,[Teenhome]
      ,[Dt_Customer]
      ,[Recency]
  FROM [PortfolioProject].[dbo].['Customer Overview Data$']
  --update null income rows to zero
  UPDATE [PortfolioProject].[dbo].['Customer Overview Data$']
  SET Income = 0
  WHERE Income is NULL
  -- Check distinct Marital status
  SELECT DISTINCT Marital_status 
  FROM [PortfolioProject].[dbo].['Customer Overview Data$']
  --Code below shows our richest customers are married.
  SELECT SUM(Income) AS Income, Marital_Status
  FROM [[PortfolioProject].[dbo].['Customer Overview Data$']
  GROUP BY Marital_Status
  ORDER BY SUM(Income) DESC
  ---Check for number of customers 
  SELECT COUNT(DISTINCT ID) AS Numbers_of_customers
  FROM [PortfolioProject].[dbo].['Customer Overview Data$']
  --Check for number of customers by education 
  SELECT COUNT(DISTINCT ID) AS Numbers_of_customers, Education
  FROM [[PortfolioProject].[dbo].['Customer Overview Data$']
  GROUP BY Education
  ORDER BY COUNT(DISTINCT ID) desc
  ----Swapping year of birth to age and place into temptable
  SELECT  [ID]
      ,Year(GETDate()) - Year_Birth AS Age
      ,[Education]
      ,[Marital_Status]
      ,[Income]
      ,[Kidhome]
      ,[Teenhome]
      ,[Dt_Customer]
      ,[Recency]
	INTO CustomerAged
  FROM [PortfolioProject].[dbo].['Customer Overview Data$']
  -- Creating age bracket and income bracket
  SELECT [Education]
      ,[Marital_Status]
      ,[Income]
	  ,CASE
	  WHEN Income <= 50000 THEN '0 - 50K'
	  WHEN Income >= 50000 AND Income <= 100000 THEN '50K - 100K'
	  WHEN Income > 100000 THEN '100K +'
	  ELSE 'Call Sidiq'
	  END AS Income_bracket
      ,[Kidhome]
      ,[Teenhome]
      ,[Dt_Customer]
      ,[Recency]
	  ,Age
	,CASE
    WHEN Age >= 0 AND Age <= 39  THEN 'Young Adults'
    WHEN Age >= 40 AND Age <= 59  THEN 'Middle Adults'
    WHEN Age >= 60 AND Age <= 99  THEN 'Old Adults'
    ELSE 'Call Sidiq'
END AS Age_Bracket
  FROM CustomerAged
  