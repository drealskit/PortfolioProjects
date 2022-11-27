/****** Script for SelectTopNRows command from SSMS  ******/
--Cleansed DIM_Products Table
SELECT  [ProductKey]
      ,[ProductAlternateKey]
     -- ,[ProductSubcategoryKey]
     -- ,[WeightUnitMeasureCode]
      --,[SizeUnitMeasureCode]
      ,P.[EnglishProductName] AS ProductName
	  ,PS.[EnglishProductSubcategoryName] AS SubCategory
	  ,PC.[EnglishProductCategoryName] AS ProductCategory
     -- ,[SpanishProductName]
      --,[FrenchProductName]
     -- ,[StandardCost]
     -- ,[FinishedGoodsFlag]
      ,P.[Color] AS Color
      --,[SafetyStockLevel]
      --,[ReorderPoint]
      --,[ListPrice]
      ,P.[Size] AS ProductSize
      --,[SizeRange]
      --,[Weight]
      --,[DaysToManufacture]
      ,P.[ProductLine] AS ProductLine
      ,[DealerPrice]
      ,[Class]
      ,[Style]
      ,P.[ModelName] AS ProductModelName
      --,[LargePhoto]
      ,P.[EnglishDescription] AS ProductDescription
     -- ,[FrenchDescription]
     -- ,[ChineseDescription]
      --,[ArabicDescription]
      --,[HebrewDescription]
      --,[ThaiDescription]
     -- ,[GermanDescription]
      --,[JapaneseDescription]
      --,[TurkishDescription]
      --,[StartDate]
      --,[EndDate]
  ,ISNULL(P.STATUS, 'Outdated') AS ProductStatus
  FROM [AdventureWorksDW2019].[dbo].[DimProduct] AS P
  LEFT JOIN [dbo].[DimProductSubcategory] AS PS ON PS.ProductSubcategoryKey = P.ProductSubcategoryKey
  LEFT JOIN [dbo].[DimProductCategory] AS PC ON PS.ProductCategoryKey = PC.ProductCategoryKey
  ORDER BY
  P.ProductKey ASC