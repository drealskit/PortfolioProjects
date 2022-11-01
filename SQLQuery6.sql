/****** Script for SelectTopNRows command from SSMS  ******/
 --Looking at Countries with highest infection rate compared to population
 
 SELECT [location],[population], MAX(total_cases) AS HighestInfectionCount , MAX(total_cases/population)*100 AS PercentPopulationInfected
  FROM [PortfolioProject].[dbo].[covid-deaths]
  --WHERE location like '%nigeria%'
  WHERE continent is not null
  GROUP by location,population
  order by PercentPopulationInfected desc

  -- Showing countries with highest death count oer population

SELECT [location], MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
  FROM [PortfolioProject].[dbo].[covid-deaths]
  --WHERE location like '%nigeria%'
  WHERE continent is not null
  GROUP by location
  order by TotalDeathCount desc

-- Showing countries with highest death count per continent

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
  FROM [PortfolioProject].[dbo].[covid-deaths]
  --WHERE location like '%nigeria%'
  WHERE continent is null  
  GROUP by location
  order by TotalDeathCount desc









-- Global Numbers

SELECT  date,SUM(new_cases) AS total_new_cases , SUM(CAST(new_deaths AS int)) AS total_new_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
  FROM [PortfolioProject].[dbo].[covid-deaths]
  --WHERE location like '%nigeria%'
  WHERE continent is not null  
 GROUP by date
  order by 1,2

  
  -- Global number without date
  SELECT SUM(new_cases) AS total_new_cases , SUM(CAST(new_deaths AS int)) AS total_new_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
  FROM [PortfolioProject].[dbo].[covid-deaths]
  --WHERE location like '%nigeria%'
  WHERE continent is not null  
  order by 1,2
  
  
  -- Looking at total population vs Vaccination
  Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS float)) OVER (Partition by dea.Location order by dea.location,dea.date) AS RollingPeopleVaccinated
  FROM [PortfolioProject].[dbo].[covid-deaths] AS dea
  JOIN [PortfolioProject].[dbo].[covid-vaccinations] AS vac
  ON dea.location = vac.location
  and dea.date = vac.date
   WHERE dea.continent is not null 
  order by 2,3
  
  
  --Using CTE when we just created a instance
  With PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
  as
  ( Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS float)) OVER (Partition by dea.Location order by dea.location,dea.date) AS RollingPeopleVaccinated
  FROM [PortfolioProject].[dbo].[covid-deaths] AS dea
  JOIN [PortfolioProject].[dbo].[covid-vaccinations] AS vac
  ON dea.location = vac.location
  and dea.date = vac.date
   WHERE dea.continent is not null 
  --order by 2,3
  )
  Select *, RollingPeopleVaccinated/population*100
  FROM PopvsVac

  
  -- Using TEMP TABLE
  DROP Table if exists #PercentPopulationVaccinated
  Create Table #PercentPopulationVaccinated
  (
  Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_vaccinations numeric,
  RollingPeopleVaccinated numeric
  )

  Insert into #PercentPopulationVaccinated
  Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS float)) OVER (Partition by dea.Location order by dea.location,dea.date) AS RollingPeopleVaccinated
  FROM [PortfolioProject].[dbo].[covid-deaths] AS dea
  JOIN [PortfolioProject].[dbo].[covid-vaccinations] AS vac
  ON dea.location = vac.location
  and dea.date = vac.date
   --WHERE dea.continent is not null 
  --order by 2,3
  Select *, RollingPeopleVaccinated/population*100
  FROM #PercentPopulationVaccinated
