/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Sales_ID]
      ,[Date]
      ,[Product_Name]
      ,[Total_Revenue]
      ,[Sales_Location]
      ,[Sales_Medium]
      ,[Sales_count]
      ,[Product_Count]
	  ,YEAR(DATE) AS Year
  FROM [PortfolioProject].[dbo].[NESTLE DATASET]

  -- Row number checking for duplicates
  ;with SalesCte AS
  (
  SELECT Sales_ID,Product_name, Total_Revenue, sales_medium,
  ROW_NUMBER() OVER (PARTITION BY Sales_ID ORDER BY Sales_ID) AS RowNumber
   FROM [PortfolioProject].[dbo].[NESTLE DATASET]
   )
   SELECT * FROM SalesCte
   WHERE RowNumber > 1
   -- Total Revenue by Sales location
   SELECT  Sales_Location, SUM(Total_Revenue) AS LocationRev
      FROM [PortfolioProject].[dbo].[NESTLE DATASET]
	  Group by Sales_Location
	  ORDER BY 2 DESC
	  --creating temp table 
	  SELECT  [Sales_ID]
      ,[Date]
      ,[Product_Name]
      ,[Total_Revenue]
      ,[Sales_Location]
      ,[Sales_Medium]
      ,[Sales_count]
      ,[Product_Count]
	  ,YEAR(DATE) AS Year
	  INTO #yeared1 
  FROM [PortfolioProject].[dbo].[NESTLE DATASET]
  -- Total salved by Product name
  SELECT  Product_Name, YEAR, SUM(Total_Revenue) AS RevbyProductName
      FROM  #yeared1 
	  Group by Product_Name, YEAR
	  ORDER BY 1,2,3 DESC
   --
  SELECT AVG(Total_Revenue) 
  from #yeared1
  ---Lets check for where revenue is greater than average 1701
  SELECT Product_name, Total_Revenue
  from #yeared1
  WHERE Total_Revenue > 1701
  -- NTILE Rank of rev by product name
    ;with ntilerev AS
	(
	SELECT  Product_Name, YEAR, SUM(Total_Revenue) AS RevbyProductName
      FROM  #yeared1 
	  Group by Product_Name, YEAR
	
	  )
	  SELECT *, Ntile(4) OVER (ORDER  BY RevbyProductName) AS Quartile
	  FROM ntilerev
	  ---revenue by sales medium 
      SELECT Product_Name,Sales_Medium, SUM(Total_Revenue) AS Revenue
	  FROM #yeared1
	  GROUP BY Product_name, Sales_Medium
	  ORDER BY 1,3
	  ---revenue by year
      SELECT Product_Name,YEAR, SUM(Total_Revenue) AS Revenue
	  FROM #yeared1
	  GROUP BY Product_name, YEAR
	  ORDER BY 1,2
      