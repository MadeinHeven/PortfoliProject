--SELECT *
--FROM PortfolioProject..CovidVaccines;


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY Location, date;

--Likely hood of dying if you contract covid in a country 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location = 'Australia'
ORDER BY  Location, date;

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location = 'Nepal'
ORDER BY  Location, date;

--Shows what percentage of population got covid
SELECT Location, date, population, total_cases, (total_cases/population)*100 as PercentofInfectedPopulation
FROM PortfolioProject..CovidDeaths
Where location = 'Australia'
ORDER BY  Location, date;

SELECT Location, date, population, total_cases, (total_cases/population)*100 as PercentofInfectedPopulation
FROM PortfolioProject..CovidDeaths
Where location = 'Nepal'
ORDER BY  Location, date;

--Country with highest infection rate
SELECT Location,  population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentofPopulationInfected
FROM PortfolioProject..CovidDeaths
Group by Location,population
ORDER BY PercentofPopulationInfected desc;

--Show countries with highest death count per population
SELECT Location,  Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
ORDER BY TotalDeathCount desc;


--Show Continent with highest death cont per population
SELECT continent,  Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not  null
Group by  continent
ORDER BY TotalDeathCount desc;


--Global Population
SELECT date, SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as New_Deaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
Group By date
ORDER BY date, Total_Cases;


--TOTAL POPULATION WITH VACCINATION
SELECT de.continent, de.location, de.date, de.population, va.new_vaccinations
From PortfolioProject..CovidDeaths de
Join PortfolioProject..CovidVaccines va
On de.location = va.location
and de.date = va.date
Where de.continent is not null
Order by de.continent, de.location;

--Total population of vaccinated people in Australia

SELECT de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(cast( va.new_vaccinations as int)) Over 
(Partition by de.location ORDER BY de.location, de.date) as VaccinatedPeople

From PortfolioProject..CovidDeaths de
Join PortfolioProject..CovidVaccines va
On de.location = va.location
and de.date = va.date
Where de.continent is not null
AND de.location = 'Australia'
Order by de.continent, de.location;


--Using CTE 
With POPVAC (Continent, Location, Date, Population, new_vaccinations, vaccinatedPeople) as  

(
SELECT de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(cast( va.new_vaccinations as int)) Over 
(Partition by de.location ORDER BY de.location, de.date) as VaccinatedPeople

From PortfolioProject..CovidDeaths de
Join PortfolioProject..CovidVaccines va
On de.location = va.location
and de.date = va.date
Where de.continent is not null
--Order by de.continent, de.location
)
SELECT *, (vaccinatedPeople/Population)*100
FROM POPVAC

--Total vaccinated people in Australia in percentage
With POPVAC (Continent, Location, Date, Population, new_vaccinations, vaccinatedPeople) as  

(
SELECT de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(cast( va.new_vaccinations as int)) Over 
(Partition by de.location ORDER BY de.location, de.date) as VaccinatedPeople

From PortfolioProject..CovidDeaths de
Join PortfolioProject..CovidVaccines va
On de.location = va.location
and de.date = va.date
Where de.continent is not null
And de.location = 'Australia'
--Order by de.continent, de.location
)
SELECT *,  (vaccinatedPeople/Population)*100 as PercentageVaccinated
FROM POPVAC
