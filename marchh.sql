/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Sales_ID]
      ,[Date]
      ,[Product_Name]
      ,[Total_Revenue]
      ,[Sales_Location]
      ,[Sales_Medium]
      ,[Sales_count]
      ,[Product_Count]
  FROM [PortfolioProject].[dbo].[NESTLE DATASET]
  -- Creating views 
  CREATE VIEW V_rev AS
  SELECT * 
  FROM [PortfolioProject].[dbo].[NESTLE DATASET]
  WHERE Total_Revenue > 200 ;
  -- testing views
  Select * from V_rev
  -- Creating stored procedures.
  CREATE PROCEDURE Temp_Employee
  AS