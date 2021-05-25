/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

-- First we want to see if the tables are right
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
FROM CovidProject..CovidDeaths
ORDER BY 1,2

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
order by PercentagePopulationI DESC



USE [CovidProject]
GO

/****** Object:  Table [dbo].[CovidVaccionations]    Script Date: 5/24/2021 7:21:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CovidVaccionations](
	[new_tests] [nvarchar](255) NULL,
	[total_tests] [nvarchar](255) NULL,
	[total_tests_per_thousand] [nvarchar](255) NULL,
	[new_tests_per_thousand] [nvarchar](255) NULL,
	[new_tests_smoothed] [nvarchar](255) NULL,
	[new_tests_smoothed_per_thousand] [nvarchar](255) NULL,
	[positive_rate] [nvarchar](255) NULL,
	[tests_per_case] [nvarchar](255) NULL,
	[tests_units] [nvarchar](255) NULL,
	[total_vaccinations] [nvarchar](255) NULL,
	[people_vaccinated] [nvarchar](255) NULL,
	[people_fully_vaccinated] [nvarchar](255) NULL,
	[new_vaccinations] [nvarchar](255) NULL,
	[new_vaccinations_smoothed] [nvarchar](255) NULL,
	[total_vaccinations_per_hundred] [nvarchar](255) NULL,
	[people_vaccinated_per_hundred] [nvarchar](255) NULL,
	[people_fully_vaccinated_per_hundred] [nvarchar](255) NULL,
	[new_vaccinations_smoothed_per_million] [nvarchar](255) NULL,
	[stringency_index] [float] NULL,
	[population_density] [float] NULL,
	[median_age] [float] NULL,
	[aged_65_older] [float] NULL,
	[aged_70_older] [float] NULL,
	[gdp_per_capita] [float] NULL,
	[extreme_poverty] [nvarchar](255) NULL,
	[cardiovasc_death_rate] [float] NULL,
	[diabetes_prevalence] [float] NULL,
	[female_smokers] [nvarchar](255) NULL,
	[male_smokers] [nvarchar](255) NULL,
	[handwashing_facilities] [float] NULL,
	[hospital_beds_per_thousand] [float] NULL,
	[life_expectancy] [float] NULL,
	[human_development_index] [float] NULL
) ON [PRIMARY]
GO

