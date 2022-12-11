/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Country]
      ,[Total]
      ,[Seniors]
      ,[Adult]
      ,[Youth]
      ,[Youngsters]
      ,[Child]
  FROM [PortfolioProject].[dbo].[population_by_age_group]

  -- Top 10 countries with highest population
  SELECT TOP 10 * 
  FROM [PortfolioProject].[dbo].[population_by_age_group]
  ORDER BY Total DESC
  -- Bottom 10 countries with low population
   SELECT TOP 10 * 
  FROM [PortfolioProject].[dbo].[population_by_age_group]
  ORDER BY Total 
  -- Top 10 countries with highest seniors 
  SELECT TOP 10 Country, Seniors
  FROM [PortfolioProject].[dbo].[population_by_age_group]
  ORDER BY Seniors DESC
  -- Top 10 countries with children
   SELECT TOP 10 Country, Child
  FROM [PortfolioProject].[dbo].[population_by_age_group]
  ORDER BY Child DESC
  -- Top 10 countries with youth
   SELECT TOP 10 Country, Youth
  FROM [PortfolioProject].[dbo].[population_by_age_group]
  ORDER BY Youth DESC
 
   --update country name 
 UPDATE [PortfolioProject].[dbo].[population_by_age_group]
 SET Country = 'Cote d Ivoire'
 WHERE Total = 27478250 and Seniors = 660329;

  UPDATE [PortfolioProject].[dbo].[population_by_age_group]
 SET Country = 'Micronesia'
 WHERE Total = 113143 and Seniors = 6661;

   UPDATE [PortfolioProject].[dbo].[population_by_age_group]
 SET Country = 'Saint Martin'
 WHERE Total = 31964 and Seniors = 3355;

 UPDATE [PortfolioProject].[dbo].[population_by_age_group]
 SET Country = 'Sint Maarten'
 WHERE Total = 44061 and Seniors = 4260;
  -- Grouping by continet 
 with cte as
 (
 SELECT *,
  CASE 
		WHEN Country IN ('') then 'Antarctica'
		WHEN Country IN ('Algeria', 'Eswatini', 'Angola' , 'Benin' , 'Botswana' , 'Burkina Faso' , 'Burundi' , 'Cameroon' , 'Cape Verde' , 'Central African Republic' , 'Chad' , 'Comoros' , 'Republic of the Congo' , 'Congo', 'Democratic Republic of Congo' , 'Côte d''Ivoire' ,'Djibouti','Equatorial Guinea','Egypt','Eritrea','Ethiopia','Gabon','Gambia','Ghana','Guinea','Guinea-Bissau','Kenya','Lesotho','Liberia','Libya','Madagascar','Malawi','Mali','Mauritania','Mauritius','Morocco','Mozambique','Namibia','Niger','Nigeria','Réunion','Rwanda','São Tomé and Príncipe','Senegal','Seychelles','Sierra Leone','Somalia','South Africa','South Sudan','Sudan','Swaziland','Tanzania','Togo','Tunisia','Uganda','Western Sahara','Zambia','Zimbabwe', 'Mayotte', 'Reunion', 'Saint Helena', 'Sao Tome and Principe', 'Cote d Ivoire') THEN 'Africa'
		WHEN Country IN ('Afghanistan',	'Armenia',	'Azerbaijan',	'Bahrain',	'Bangladesh',	'Bhutan',	'Brunei',	'Cambodia',	'China',	'East Timor',	'Georgia',	'India',	'Indonesia',	'Iran',	'Iraq',	'Israel',	'Japan',	'Jordan',	'Kazakhstan',	'Kuwait',	'Kyrgyzstan',	'Laos',	'Lebanon',	'Malaysia',	'Maldives',	'Mongolia',	'Myanmar',	'Nepal',	'North Korea',	'Oman',	'Pakistan',	'Palestine',	'The Philippines',	'Qatar',	'Russia',	'Saudi Arabia',	'Singapore',	'South Korea',	'Sri Lanka',	'Syria',	'Tajikistan',	'Thailand',	'Turkey',	'Turkmenistan',	'United Arab Emirates',	'Uzbekistan',	'Vietnam',	'Yemen', 'Hong Kong', 'Macao', 'Philippines', 'Taiwan') THEN 'Asia'	
		WHEN Country IN ('Albania',	'Andorra',	'Austria',	'Belarus',	'Belgium',	'Bosnia and Herzegovina',	'Bulgaria',	'Croatia',	'Cyprus',	'Czechia',	'Denmark',	'Estonia',	'Finland',	'France',	'Georgia',	'Germany',	'Greece',	'Hungary',	'Iceland',	'Republic of Ireland',	'Italy',	'Kosovo',	'Latvia',	'Liechtenstein',	'Lithuania',	'Luxembourg',	'North Macedonia',	'Malta',	'Moldova',	'Monaco',	'Montenegro',	'Netherlands',	'Norway',	'Poland',	'Portugal',	'Romania',	'Russia',	'San Marino',	'Serbia',	'Slovakia',	'Slovenia',	'Spain',	'Sweden',	'Switzerland',	'Turkey',	'Ukraine',	'United Kingdom',	'Vatican City', 'Faeroe Islands', 'Gibraltar', 'Guernsey', 'Ireland', 'Isle of Man', 'Jersey')	THEN 'Europe'		
		WHEN Country IN ('Anguilla', 'Antigua and Barbuda', 'British Virgin Islands', 'Canada','Cayman Islands','Mexico','United States','Navassa Island','Puerto Rico','United States Virgin Islands','Dominican Republic','Cuba','Greenland','Haiti','Belize','Costa Rica','El Salvador','Guatemala','Honduras','Guadeloupe','Martinique','Nicaragua','Panama','Jamaica','Bahamas','Barbados','Dominica', 'Grenada', 'Montserrat','Saint Kitts and Nevis','Saint Lucia','Saint Pierre and Miquelon','Saint Vincent and the Grenadines', 'Turks and Caicos Islands', 'Sint Maarten', 'Saint Martin') THEN 'North America'
		WHEN Country IN ('Aruba','Brazil', 'Bermuda', 'Bonaire Sint Eustatius and Saba','Curacao',	'Argentina',	'Bolivia',	'Chile',	'Colombia',	'Ecuador',	'Falkland Islands',	'French Guiana',	'Guyana',	'Paraguay',	'Peru',	'South Georgia and the South Sandwich Islands',	'Suriname',	'Trinidad and Tobago',	'Uruguay',	'Venezuela') THEN 'South America'
		WHEN Country IN ('Australia',	'Fiji', 'Cook Islands',	'New Zealand',	'Micronesia',	'Kiribati',	'Marshall Islands',	'Nauru',	'Palau',	'Papua New Guinea',	'American Samoa',	'Solomon Islands',	'Tonga',	'Tuvalu',	'Vanuatu', 'French Polynesia','Guam','Niue', 'Northern Mariana Islands','Samoa','Tokelau', 'Wallis and Futuna','Flores', 'Lombok', 'Melanesia', 'New Caledonia', 'New Guinea', 'Sulawesi', 'Sumbawa', 'Timor') THEN 'Oceania/Australia'
		end Continent
  FROM [PortfolioProject].[dbo].[population_by_age_group]
  ) 
  SELECT MAX(Youngsters), Continent
  FROM cte
  GROUP BY Continent
  SELECT SUM(CAST(Total AS bigint)) AS Population, Continent
  FROM cte
  GROUP BY Continent
  ORDER BY 1 DESC
