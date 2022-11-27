/****** Script for SelectTopNRows command from SSMS  ******/
--cleansed dim_customer  table
SELECT  C.[CustomerKey] AS CustomerKey
     -- ,[GeographyKey]
     -- ,[CustomerAlternateKey]
     -- ,[Title]
      ,C.[FirstName] AS FirstName
      --,[MiddleName]
      ,C.[LastName] AS LastName
	   ,C.[FirstName] + ' ' + [LastName] AS FullName,
      --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
	  CASE C.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' END AS Gender 
      --,[Gender]
     -- ,[EmailAddress]
     -- ,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      ---,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
     -- ,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
      ,C.[DateFirstPurchase] AS DateOfFirstPurchase,
      --,[CommuteDistance]
	  G.city AS CustomerCity
  FROM [AdventureWorksDW2019].[dbo].[DimCustomer] AS C
  LEFT JOIN [dbo].[DimGeography] AS G 
  ON G.GeographyKey = C.GeographyKey
  ORDER BY CustomerKey ASC