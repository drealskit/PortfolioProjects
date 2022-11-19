/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [set_num]
      ,[name]
      ,[year]
      ,[theme_id]
      ,[num_parts]
      ,[img_url]
  FROM [Rebrickable].[dbo].[sets]

  -- what is the total number of parts per theme
  
  select s.*,t.*
  from [Rebrickable].[dbo].[sets] s
  inner join [dbo].[themes] t
  ON s.theme_id = t.id

  -- creating a view to query from 

  create view analytics_main

   as
   select s.set_num,s.name as set_name,s.year,s.theme_id,CAST(s.num_parts as numeric) num_parts, t.name as theme_name, t.parent_id, p.name as parent_theme_name
  from [Rebrickable].[dbo].[sets] s
  left join [dbo].[themes] t
  ON s.theme_id = t.id
  left join [dbo].[themes] p
  ON t.parent_id = p.id;
  -- selecting from the views
  select * from dbo.analytics_main

--- 1) What is the total number of parts per theme

select theme_name, sum(num_parts)as total_number_part
from dbo.analytics_main
--Where parent_theme_name is not null
group by theme_name
order by 2 desc

-- 2) What is total number of parts per year

select year, sum(num_parts)as total_number_part
from dbo.analytics_main
Where parent_theme_name is not null
group by year
order by 2 desc

--3 How many sets where created in each century in the data set
 select * from dbo.analytics_main
 
 select COUNT(set_num) as First_century 
 from dbo.analytics_main
 WHERE year BETWEEN 1901 AND 2000 AND parent_theme_name is not null
 
 select COUNT(set_num) as Second_century 
 from dbo.analytics_main
 WHERE year BETWEEN 2001 AND 2100 AND parent_theme_name is not null

 -- another way of doing this (to confirm)
 select Century, COUNT(set_num) as total_sets
  from dbo.analytics_main
  Where parent_theme_name is not null
  Group by Century

  -- 4) What percentage of sets ever released in the 21st Century where trains themed
;with cte as
(
  select Century, theme_name, Count(set_num) as total_set_num 
  from dbo.analytics_main
  WHERE Century = '21st_Century'
  group by Century,theme_name
)
select SUM(total_set_num), SUM(total)
from(
     select Century, theme_name, total_set_num, SUM(total_set_num) OVER () as total, CAST(1.00 * total_set_num/SUM(total_set_num) OVER () AS decimal(5,4)) * 100 AS percentage-- FLOOR is to round up to whole number
     from cte
--order by 3 DESC
      )m
where theme_name like '%train%'

--what was the popular theme by year in term of set released in the 21st Century
select year, theme_name, total_set_num
FROM (
select  theme_name, year, COUNT(set_num) total_set_num, ROW_NUMBER() OVER (PARTITION BY year ORDER BY COUNT(set_num) desc) AS rn
FROM dbo.analytics_main 
WHERE Century = '21st_Century'
and parent_theme_name is not null
group by year, theme_name
)M
where rn = 1
order by year desc

 --What is the most produced color of lego ever in terms of quantity of parts?
select color_name, sum(quantity) as quantity_of_parts
from 
	(
		select
			inv.color_id, inv.inventory_id, inv.part_num, cast(inv.quantity as numeric) quantity, inv.is_spare, c.name as color_name, c.rgb, p.name as part_name, p.part_material, pc.name as category_name
		from inventory_parts inv
		inner join colors c
			on inv.color_id = c.id
		inner join parts p
			on inv.part_num = p.part_num
		inner join part_categories pc
			on part_cat_id = pc.id
	)main

group by color_name
order by 2 desc