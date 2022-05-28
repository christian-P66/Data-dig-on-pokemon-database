
--Covid 19 Data Exploration 
--Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

-------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM Portfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..CovidDeaths
ORDER BY 1,2;

--------------------------------------------------------------------------------------------------------------------------


--Looking at Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths
WHERE location = 'japan'
ORDER BY 1, 2;

--Using the LIKE operator 

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2;

--------------------------------------------------------------------------------------------------------------------------


--Looking at Countries with Highest Infection rate compared to Population

SELECT Location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population)) * 100 AS percent_population_infected
FROM Portfolio_Project..CovidDeaths
GROUP BY population,location
ORDER BY percent_population_infected DESC;

--------------------------------------------------------------------------------------------------------------------------


--Showing Countries with Highest Death Count per Population
--Converting data type

SELECT location , MAX(CONVERT(INTEGER,total_deaths)) AS Total_Death_Count
FROM Portfolio_Project..CovidDeaths
WHERE continent  IS NOT NULL
GROUP BY location 
ORDER BY Total_Death_Count DESC;


--Showing Continents with Highest Death Count per Population

SELECT location, MAX(CONVERT(INTEGER,total_deaths)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
WHERE continent IS NULL AND location NOT LIKE '%income%' AND location NOT IN ('international', 'World', 'European Union')
GROUP BY location
ORDER BY TotalDeathCount DESC;


--Showing Highest Death Count per income class

SELECT location AS Income_Class, MAX(CONVERT(INTEGER,total_deaths)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
WHERE location LIKE '%income%'
GROUP BY location
ORDER BY TotalDeathCount DESC;

--------------------------------------------------------------------------------------------------------------------------


--GLOBAL NUMBERS
--New Cases, New Deaths, Death Percentage

SELECT date, SUM(new_cases) AS Global_New_Cases, SUM(CONVERT(INTEGER,new_deaths)) AS Global_Daily_Deaths,
SUM(CONVERT(INTEGER,new_deaths))/ SUM(new_cases) * 100 AS New_Death_Percentage
FROM Portfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;

--Total Cases, Total Deaths, Death Percentage 

SELECT SUM(new_cases) AS TotalCases ,SUM(CONVERT(INTEGER, new_deaths)) AS TotalDeaths,
SUM(CONVERT(INTEGER,new_deaths))/ SUM(new_cases) * 100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths
ORDER BY 1, 2;

--------------------------------------------------------------------------------------------------------------------------


--Looking at Total Population vs Vaccination
--JOIN

select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations 
from Portfolio_Project..CovidVacinations VAC 
join Portfolio_Project..CovidDeaths DEA
	on dea.location = vac.location 
		and dea.date = vac.date 
where vac.new_vaccinations is not null; 

--------------------------------------------------------------------------------------------------------------------------


--Using CTE

WITH PopulationVsVac (continent, location, Date, population, new_vaccinations, Rolling_Vaccinations)
AS 
(
SELECT dea.date, dea.location, dea.continent, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations)) 
OVER (Partition by dea.Location Order by dea.location, dea.Date) AS Rolling_Vaccinations
FROM Portfolio_Project..CovidVacinations VAC
   JOIN Portfolio_Project..CovidDeaths DEA
     ON DEA.location = VAC.location
     AND DEA.date = VAC.date
   WHERE dea.continent IS NOT NULL
   --ORDER BY 2,3
 )
 SELECT*,(Rolling_Vaccinations/population)*100 AS vaccination_percentage
 FROM PopulationVsVac;

--------------------------------------------------------------------------------------------------------------------------


/*TEMP TABLE*/

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
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Select *, (RollingPeopleVaccinated/Population)*100 AS Vaccination_Percentage
From #PercentPopulationVaccinated;

--------------------------------------------------------------------------------------------------------------------------


 --Creating View to store data for later visualization
 --Daily cases and deaths

 CREATE VIEW Cases_And_Deaths_Daily AS
 SELECT date, SUM(new_cases) AS GlobalNewCases, SUM(CONVERT(INTEGER,new_deaths)) AS GlobalDailyDeaths,
SUM(CONVERT(INTEGER,new_deaths))/ SUM(new_cases) * 100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date;


--Percentage of the population vaccinated

CREATE VIEW Population_Vaccinated_Percentage AS
SELECT dea.continent , dea.location , dea.date , vac.new_vaccinations, 
	SUM(CONVERT(INTEGER,vac.new_vaccinations)) OVER(partition by vac.location order by vac.location ,vac.date DESC)
	AS rolling_people_vaccinated
FROM Portfolio_Project..CovidDeaths dea 
JOIN Portfolio_Project..CovidVacinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date 
WHERE vac.new_vaccinations is not null;

--------------------------------------------------------------------------------------------------------------------------
