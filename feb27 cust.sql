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
  WHERE INCOME IS NULL
  -- setting null income to 0
  UPDATE [dbo].['Customer Overview Data$']
  SET Income = 0
  WHERE Income IS NULL
  SELECT DISTINCT Marital_status
  FROM [dbo].['Customer Overview Data$']
  -- CHECKING Total income based on married status 
  SELECT Marital_status, SUM(Income)
  FROM [dbo].['Customer Overview Data$']
  GROUP BY Marital_Status
  ORDER BY Income