

--Total Deaths Vs Total Cases
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
from CovidDeaths$
Order By 1,2

---Total Cases Versus Population
Select location, date, total_cases, new_cases, population, (total_cases/population)*100 AS population_percent_infected
from CovidDeaths$
Order By 1,2 

--Countries with Highest infection rate compared to Population
Select location,population, max(total_cases) AS Highest_Infection_count,  max((total_cases/population))*100 AS population_percent_infected
from CovidDeaths$
Group By location,population
Order By population_percent_infected Desc

--Countries with Highest Death Count compared to Population
Select location,population, max(cast(total_deaths as int)) AS Total_Death_count, max((total_deaths/total_cases))*100 AS death_percent_Population
from CovidDeaths$
Where continent IS NOT NULL
Group By location, population
Order By Total_Death_count Desc

Select location,population, max(cast(total_deaths as int)) AS Total_Death_count, max((total_deaths/total_cases))*100 AS death_percent_Population
from CovidDeaths$
Where continent IS not NULL and Population is not Null
Group By location, population
Order By Total_Death_count Desc

--Continents with highest death count
Select continent, max(cast(total_deaths as int)) AS Total_Death_count, max((total_deaths/total_cases))*100 AS death_percent_Population
from CovidDeaths$
Where continent IS NOT NULL
Group By continent
Order By Total_Death_count Desc

--Continents with highest number of cases
Select continent, Sum(total_Cases) AS Total_Case_count
From CovidDeaths$
Where continent IS NOT NULL
Group By continent
Order By Total_Case_count Desc

--GLOBAL NUMBERS
Select Sum(new_cases) AS Total_NewCases, Sum(Cast(new_deaths as int)) AS Total_NewDeaths, Sum(Cast(new_deaths as int))/Sum(new_cases)*100 AS DeathPercent
From CovidDeaths$
Where Continent is not null
--Group by date
Order By 1,2 

--Total Populations Vs Vaccination Using CTE
With PopVsVac (date, Continent, location, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select Dea.date, Dea.continent, Dea.location, Dea.population, vac.new_vaccinations
, Sum(Convert( int, vac.new_vaccinations)) Over (Partition By Dea. Location Order By Dea. Location, Dea. Date) As RollingPeopleVaccinated
From CovidDeaths$ as Dea
Join CovidVaccinations$ as Vac
On Dea.date = Vac.date 
and Dea.location = Vac.location
Where Dea.continent is not null
--Order By 1,2
)
Select *, (RollingPeopleVaccinated/population)*100
From PopVsVac

--Total Populations Vs Vaccination Using Temp Tables
Drop Table if exists  #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Date datetime,
Continent nvarchar(255),
Location nvarchar (255),
Population numeric,
NewVaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert Into #PercentPopulationVaccinated
Select Dea.date, Dea.continent, Dea.location, Dea.population, vac.new_vaccinations
, Sum(Cast( vac.new_vaccinations as int)) Over (Partition By Dea. Location Order By Dea. Location,Dea.date) As RollingPeopleVaccinated
From CovidDeaths$ as Dea
Inner Join CovidVaccinations$ as Vac
On Dea.date = Vac.date 
and Dea.location = Vac.location
Where Dea.continent is not null 

Select *, (RollingPeopleVaccinated/population)*100 AS PercentVaccinated
From #PercentPopulationVaccinated

--Creating View to Store Data for later Visualization
Create View PercentPopulationVaccinated as
Select Dea.date, Dea.continent, Dea.location, Dea.population, vac.new_vaccinations
, Sum(Cast( vac.new_vaccinations as int)) Over (Partition By Dea. Location Order By Dea. Location,Dea.date) As RollingPeopleVaccinated
From CovidDeaths$ as Dea
Inner Join CovidVaccinations$ as Vac
On Dea.date = Vac.date 
and Dea.location = Vac.location
Where Dea.continent is not null

--Global Numbers
Create View GlobalNumbers as
Select Sum(new_cases) AS Total_NewCases, Sum(Cast(new_deaths as int)) AS Total_NewDeaths, Sum(Cast(new_deaths as int))/Sum(new_cases)*100 AS DeathPercent
From CovidDeaths$
Where Continent is not null



--Continents with highest number of cases
Create View ContinentsWithHighestNumberOfCases  as
Select continent, Sum(total_Cases) AS Total_Case_count
From CovidDeaths$
Where continent IS NOT NULL
Group By continent


----Continents with highest Death Count
Create View ContinentsWithHighestDeathCount  as
Select continent, max(cast(total_deaths as int)) AS Total_Death_count, max((total_deaths/total_cases))*100 AS death_percent_Population
from CovidDeaths$
Where continent IS NOT NULL
Group By continent
