-- Discovered that the Datatype for the column total_deaths and total_cases were nvarchar intead of float so converted them.
	-- Since Location was both country and continent for some values I excluded continent with a where-statement

ALTER TABLE PorfolioProject.dbo.CovidDeaths
ALTER COLUMN total_cases int 

ALTER TABLE PorfolioProject.dbo.CovidDeaths
ALTER COLUMN total_deaths int 

ALTER TABLE PorfolioProject.dbo.CovidDeaths
ALTER COLUMN new_cases int 

ALTER TABLE PorfolioProject.dbo.CovidDeaths
ALTER COLUMN new_deaths int


-- Selecting the Data we are going to be using:

SELECT Location, date, new_cases, total_cases, total_deaths, population
FROM PorfolioProject.dbo.CovidDeaths
Where location = 'Sweden'
ORDER BY 1,2

--Looking at Mortality rate in (Sweden) 
--(Expressed as percentages)

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as MortalityRate
FROM PorfolioProject.dbo.CovidDeaths
Where location like 'Sweden'
ORDER BY 1,2


-- Comparing total cases to Population (Sweden)
-- Shows what percentage of population that got Covid 
SELECT Location, date, population, total_cases, (total_cases/population)*100 as PercentInfectedPopulation
FROM PorfolioProject.dbo.CovidDeaths
Where location like 'Sweden'
ORDER BY 1,2


-- What Country has the highest infectiousrate in percentage?

SELECT Location, population, MAX(total_cases) as TotalCases, (MAX(total_cases)/population)*100 as PercentInfectedPopulation
FROM PorfolioProject.dbo.CovidDeaths 
WHERE continent is not NULL
GROUP BY Location, population
ORDER BY PercentInfectedPopulation desc


-- What Country has the highest percentage of the population die in Covid?
-- Since Location was both country and continent for some values I excluded continent with a where-statement

SELECT Location, population, MAX(total_deaths) as TotalDeaths, (MAX(total_deaths)/population)*100 as PercentageOfPopulationDeaths
FROM PorfolioProject.dbo.CovidDeaths 
WHERE continent is not NULL
GROUP BY Location, population
ORDER BY PercentageOfPopulationDeaths desc


--Total death count per country

SELECT Location, MAX(total_deaths) as TotalDeaths
FROM PorfolioProject.dbo.CovidDeaths 
WHERE continent is not NULL
GROUP BY Location
ORDER BY TotalDeaths desc


-- BREAK DOWN PER CONTINENT

SELECT location, MAX(total_deaths) as TotalDeaths
FROM PorfolioProject.dbo.CovidDeaths 
WHERE continent is NULL
GROUP BY location
ORDER BY TotalDeaths desc

-- GLobal numbers

SELECT SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths, (SUM(new_deaths)/SUM(new_cases))*100 as Mortality_Rate
FROM PorfolioProject.dbo.CovidDeaths
WHERE continent is not null 
ORDER BY 1,2



-- Joining 2 tables
-- Total vaccinations per capita

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.location, dea.date)
FROM PorfolioProject.dbo.CovidDeaths dea
Join PorfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3



Create VIEW SwedenCovid as
SELECT Location, date, new_cases, total_cases, total_deaths, population
FROM PorfolioProject.dbo.CovidDeaths
Where location = 'Sweden'

