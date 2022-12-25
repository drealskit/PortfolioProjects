/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [order_id]
      ,[order_date]
      ,[ship_date]
      ,[ship_mode]
      ,[customer_name]
      ,[segment]
      ,[state]
      ,[country]
      ,[market]
      ,[region]
      ,[product_id]
      ,[category]
      ,[sub_category]
      ,[product_name]
      ,[sales]
      ,[quantity]
      ,[discount]
      ,[profit]
      ,[shipping_cost]
      ,[order_priority]
      ,[year]
  FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  -- Let's count the number of customer we make loss from
  SELECT COUNT (DISTINCT customer_name) AS Customer
  FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  WHERE PROFIT < 0 -- Made loss on 795 customer so far 
  -- changng data type of order date and ship date
  ALTER TABLE [PortfolioProject].[dbo].[SuperStoreOrders$] 
  ALTER COLUMN order_date Date;

  ---Cleaning up the region data 
  SELECT *  FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  SELECT DISTINCT country,region
  FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  WHERE region = 'South'
  UPDATE [PortfolioProject].[dbo].[SuperStoreOrders$]
  SET region = 'North America'
  WHERE country = 'Canada' 
  -- we now have 14 regions
  SELECT DISTINCT region FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  ---checking how long order is being processed 
  ;with cte as
  (
  SELECT order_date,ship_date, ship_mode, order_priority , DATEDIFF(day,order_date,ship_date) AS delivery_time
  FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  WHERE order_priority = 'High' AND ship_mode = 'First class' 
  )
  SELECT * FROM cte
  WHERE delivery_time > 2
  --calculate loss over the years
  SELECT SUM(profit) AS Loss,year
  FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  WHERE profit < 0
  GROUP BY year
  order by 2
  --Calculate the profit over the years
   SELECT SUM(profit) AS profit,year
  FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  WHERE profit > 0
  GROUP BY year
  order by 2
  -- Calculate sum of sales grouped by catergory 
  SELECT SUM(sales) AS sales_by_catergory,category, year
  FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  WHERE sales > 0
  GROUP BY category,year
  ORDER BY 3 -- Technology has been the highest sales over the years.
  --- checking sales 
  ; with pft as
  (
  SELECT profit, sales, region, (profit / nullif(sales,0)) AS profit_margin FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  )
  SELECT region, SUM(profit_margin) AS total_profit FROM pft
  GROUP BY region
  order by 2

    ; with pfh as
  (
  SELECT profit, sales, region, (profit / nullif(sales,0)) AS profit_margin FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  )
  SELECT region, SUM(profit) AS tprofit FROM [PortfolioProject].[dbo].[SuperStoreOrders$]
  GROUP BY region
  order by 2
  