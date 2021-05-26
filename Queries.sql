/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

-- First we want to see if the tables were imported right
SELECT  *
FROM CovidDeaths
ORDER BY 3,4

SELECT *
FROM CovidVaccinations
ORDER BY 3,4

-- Then let's look at Total Cases vs Total Deaths:
SELECT  Location
       ,date
       ,total_cases
       ,new_cases
       ,total_deaths
       ,population
FROM CovidDeaths
ORDER BY 1,2

-- Now, which is the likelihood of dying if you contract covid per country?
SELECT  Location 
       ,(SUM(total_deaths)/SUM(total_cases))*100 AS DeathPercentage
FROM CovidDeaths
GROUP BY location
ORDER BY 1,2 

 -- Let's look at the Total cases vs population (percentage the population that got covid)
SELECT  Location
       ,date
       ,total_cases
       ,population
       ,(total_cases/population)*100 AS PercentagePopulationInfected
FROM CovidDeaths --Where location like '%states%'
ORDER BY 1,2

-- Which are the countries with highest infection rate compared to population
SELECT  location
       ,population
       ,MAX(total_cases)                  AS Highest_Infection
       ,MAX((total_cases/population))*100 AS Percentage_Infected
FROM CovidDeaths
WHERE continent is not null 
GROUP BY  location
         ,population
ORDER BY Percentage_Infected DESC

-- Countries with Highest Death Count
SELECT  location
       ,MAX(cast(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidDeaths
--WHERE continent is not null 
WHERE continent <> '' AND continent <> 'NULL'
GROUP BY  location
ORDER BY TotalDeathCount desc

-- Continents with the highest death count per population
SELECT  continent
       ,MAX(cast(Total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent <> '' AND continent <> 'NULL'
GROUP BY  continent
ORDER BY TotalDeathCount desc

-- Global Cases, Deaths and Percentage of Deaths
SELECT  SUM(new_cases)                                  AS total_cases
       ,SUM(cast(new_deaths                AS SIGNED)) AS total_deaths
       ,SUM(cast(new_deaths AS SIGNED))/SUM(New_Cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent <> '' AND continent <> 'NULL'
ORDER BY 1,2 

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has received at least one Covid Vaccine
SELECT  D.continent
       ,D.location
       ,D.date
       ,D.population
       ,V.new_vaccinations 
       ,SUM(CAST(V.new_vaccinations AS SIGNED)) 
       OVER (Partition by D.Location ORDER BY D.location,dea.Date) AS RollingPeopleVaccinated 
--        ,(RollingPeopleVaccinated/population)*100
FROM CovidDeaths D
JOIN CovidVaccinations V
ON D.location = V.location AND D.date = V.date
WHERE D.continent is not null
ORDER BY 2,3 


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 