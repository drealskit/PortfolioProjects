/****** Script for SelectTopNRows command from SSMS  ******/


SELECT  [ID]
      ,[Name] AS 'Athlete name' -- Renamed column
      ,CASE WHEN SEX = 'M' THEN 'Male' ELSE 'Female' END AS Gender -- Formating text and column name 
      ,[Age]
	  ,CASE WHEN [Age] < 18 THEN 'Under 18'
			WHEN [Age] BETWEEN 18 AND 25 THEN '18-25'
			WHEN [Age] BETWEEN 25 AND 30 THEN '25-30'
			WHEN [Age] > 30 THEN 'Over 30'
		END AS [Age Group]
      ,[Height]
      ,[Weight]
      ,[NOC] AS 'Nation Code'  -- Explained the abbreviation
	--  ,CHARINDEX(' ', Games)-1 AS 'Example 1'
	--  ,CHARINDEX(' ', REVERSE(Games))-1 AS 'Example 2'
	  ,LEFT(Games, CHARINDEX(' ', Games) -1) AS 'Year'  --- Spliting the games column using space--
--	  ,RIGHT(Games, CHARINDEX(' ', REVERSE(Games))-1) AS 'Season' -- Spliting the games column using space
 --     ,[Games]
 --     ,[City] -- not needed
      ,[Sport]
      ,[Event]
      ,CASE WHEN [Medal] = 'NA' THEN 'Not Registered' ELSE Medal END AS Medal -- replacing NA 
  FROM [olympic_games].[dbo].[athletes_event_results]
  WHERE RIGHT(Games, CHARINDEX(' ', REVERSE(Games))-1) = 'Summer' -- filtering to show only summer games
 
