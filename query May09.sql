//****** Script for SelectTopNRows command from SSMS  ******/

#first task

SELECT SUM(TOTAL_REVENUE) AS REVENUE, SALES_LOCATION, Sales_Medium

FROM [dbo].[NESTLE DATASET]

GROUP BY Sales_Location, Sales_Medium

SELECT *  FROM [dbo].[NESTLE DATASET]
#second task
SELECT SUM(TOTAL_REVENUE)

FROM [dbo].[NESTLE DATASET]
#third task
CREATE PROCEDURE Reve_tax @sales_location nvarchar(60), @sales_medium nvarchar(10)

AS 
SELECT * FROM [dbo].[NESTLE DATASET] WHERE SALES_LOCATION = @sales_location AND Sales_medium = @sales_medium

GO:

EXEC Reve_tax @sales_location = 'Australian Capital Territory' , @sales_medium = 'Online'
SELECT SUM(TOTAL_REVENUE)

FROM [dbo].[NESTLE DATASET]

SELECT * INTO test_da

FROM
(SELECT PRODUCT_NAME, SALES_LOCATION, TOTAL_REVENUE , Sales_Medium
FROM [PortfolioProject].[dbo].[NESTLE DATASET]
WHERE Sales_Medium = 'online'
UNION
SELECT PRODUCT_NAME, SALES_LOCATION, TOTAL_REVENUE ,Sales_Medium
FROM [PortfolioProject].[dbo].[NESTLE DATASET]
WHERE Sales_Medium = 'direct') as tmp

select PRODUCT_NAME, SUM(TOTAL_REVENUE) ,Sales_Medium from 
test_da
GROUP BY Product_Name, Sales_medium , Total_Revenue





SELECT COUNT(DISTINCT SALES_LOCATION) 
FROM [dbo].[NESTLE DATASET]






c

SELECT Sales_Id, Date, Product_name, sales_medium, t
INTO online_rev1
FROM [dbo].[NESTLE DATASET]
WHERE Sales_Medium = 'direct'

select * FROM online_rev1
SELECT Sales_Id, Date, Product_name, sales_medium
INTO online_rev
FROM [dbo].[NESTLE DATASET]
WHERE Sales_Medium = 'online'

select * FROM online_rev
select * FROM online_rev1






