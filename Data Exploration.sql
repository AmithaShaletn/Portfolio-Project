

select * from COVIDDEATH
Where continent is not null

select * from COVIDVACCINE
Where continent is not null

----Looking at Total Cases vs Total Deaths
----Shows likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,total_deaths/nullif(total_cases,0)*100 as Deathpercentage from COVIDDEATH
where location like 'Brazil'
Order By 1, 2

---Looking at Total Cases vs Total Deaths
----Shows what percentage of population got covid

select location,date,total_cases,population,total_cases / nullif(population,0)*100 as PercentagePopulationInfected from COVIDDEATH
where location like 'Brazil'
Order By 1,2

---Looking at countries with Highest Infection Rate compared to population.
select location,Population ,Max(total_cases) as HighestInfectionCount,Max(total_cases / nullif(population,0))*100 as PercentagePopulationInfected from COVIDDEATH
Where continent is not null
Group by location,population
Order By PercentagePopulationInfected desc

--Showing the countries with highest death count per population 

Select Location,Max(Total_deaths) as TotalDeathCount From COVIDDEATH
Where continent is not null
Group by Location
Order By TotalDeathCount desc

---Lets Break things down by continent 

---Showing the continents with highest death ccounts

Select continent,Max(Total_deaths) as TotalDeathCount From COVIDDEATH
Where continent is not null
Group by continent
Order By TotalDeathCount desc

----- GLOBAL NUMBERS

select nullif(sum(new_cases),0) as total_cases,nullif(sum(new_deaths),0) as total_deaths,nullif(sum(new_deaths),0)/nullif(sum(new_cases),0) * 100 as DeathPercentage
from COVIDDEATH
Where continent is not null
--Group By date
Order By 1, 2

---Looking at Total population vs vaccination 

Select dea.continent ,dea.location ,dea.date ,dea.population ,vac.new_vaccinations
,sum(vac.new_vaccinations) Over (Partition By dea.location Order By dea.location,dea.date) as RollingPeoplevaccinated
---(RollingPeoplevaccinated/population) *100
From COVIDDEATH dea
Join VACCINE vac
On dea.location = vac.location
And dea.date = vac.date
where dea.continent is not null
order by 1,2,3

---Use CTE

With POPVsVACC (Continent,Location,Date,Population,New_Vaccinations,RollingPeoplevaccinated)
as 
(Select dea.continent ,dea.location ,dea.date ,dea.population ,vac.new_vaccinations
,sum(vac.new_vaccinations) Over (Partition By dea.location Order By dea.location,dea.date) as RollingPeoplevaccinated
---(RollingPeoplevaccinated/population) *100
From COVIDDEATH dea
Join VACCINE vac
On dea.location = vac.location
And dea.date = vac.date
where dea.continent is not null
)
---order by 1,2,3)
Select *,(RollingPeoplevaccinated/Population)*100 From POPVsVACC




-----Create View to store data for later visualisations

Create View PercentPopulationvaccinated as
Select dea.continent ,dea.location ,dea.date ,dea.population ,vac.new_vaccinations
,sum(vac.new_vaccinations) Over (Partition By dea.location Order By dea.location,dea.date) as RollingPeoplevaccinated
---(RollingPeoplevaccinated/population) *100
From COVIDDEATH dea
Join VACCINE vac
On dea.location = vac.location
And dea.date = vac.date
where dea.continent is not null
---order by 2,3

Select * from PercentPopulationvaccinated




