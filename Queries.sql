-- First we want to see if the tables are right

--Select *
--From CovidProject..CovidDeaths
--where continent is not null
--order by 3,4

--SELECT *
--FROM CovidProject..CovidVaccinations
--ORDER BY 3,4

-- Then let's look at Total Cases vs Total Deaths:
Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject..CovidDeaths
order by 1,2

--This is the likelihood of dying is you contract covid in your country:
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at the Total cases vs population (porcentage the population that got covid)
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulationInfected
From CovidProject..CovidDeaths
--Where location like '%states%'
order by 1,2

-- Which are the countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From CovidProject..CovidDeaths
where continent is not null
Group by location, population
order by PercentagePopulationI