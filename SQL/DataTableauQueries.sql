/*
Queries used for Tableau Visualization 
*/



-- 1. 
SELECT  SUM(new_cases)                                  AS total_cases
       ,SUM(cast(new_deaths                    AS SIGNED)) AS total_deaths
       ,SUM(cast(new_deaths AS SIGNED))/SUM(New_Cases)*100 AS DeathPercentage
FROM CovidDeaths
--WHERE continent is not null
WHERE continent not IN ('', 'NULL')
ORDER BY 1,2;

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them 
-- The Second includes "International"  Location

--Select SUM(new_cases) as total_cases, 
--SUM(cast(new_deaths as int)) as total_deaths, 
--SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From CovidDeaths
--where location = 'World'
--Group By date
--order by 1,2


-- 2.  Death count per continent
SELECT  continent
       ,SUM(cast(new_deaths AS SIGNED)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent not IN ('', 'NULL')
AND location not IN ('World', 'European Union', 'International') 
GROUP BY  continent
ORDER BY TotalDeathCount desc;

-- 3. Death count per country

SELECT  location
       ,SUM(cast(new_deaths AS SIGNED)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent not IN ('', 'NULL')
AND location not IN ('World', 'European Union', 'International') 
GROUP BY  location
ORDER BY TotalDeathCount desc;


-- 4. Highest Percent of Population Infected per Country (with NULL control)
SELECT  Location
       ,Population
       ,COALESCE(MAX(total_cases),  0)                  AS HighestInfectionCount
       ,COALESCE(MAX((total_cases/population))*100, 0) AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY  Location
         ,Population
ORDER BY PercentPopulationInfected desc;


-- 5. Percent of Population Infected per Country (with NULL control)
SELECT  Location
       ,Population
       ,DATE(date)
       ,IFNULL(total_cases, 0)                 AS InfectionCount
       ,IFNULL(((total_cases/population)*100), 0) AS PercentPopulationInfected
FROM CovidDeaths
ORDER BY PercentPopulationInfected desc;


-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out


-- 6. Percentage of population that receive at least one vaccine
CREATE View ViewRollingVaccinated AS
SELECT  D.continent
       ,D.location
       ,D.date
       ,D.population 
       ,IFNULL(MAX(V.total_vaccinations),0) AS RollingPeopleVaccinated 
FROM CovidDeaths D
JOIN CovidVaccinations V
ON D.location = V.location AND D.date = V.date
WHERE D.continent not IN ('', 'NULL')
GROUP BY  D.continent
         ,D.location
         ,D.date
         ,D.population
ORDER BY 1
         ,2
         ,3;

SELECT  continent,
        location,
        DATE(date),
        population,
        RollingPeopleVaccinated
      ,(RollingPeopleVaccinated/population)*100 AS PercentagePeopleVaccinated
FROM ViewRollingVaccinated;



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
order by 1,2



-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc