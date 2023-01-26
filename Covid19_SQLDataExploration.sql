--Looking at  covid deaths and vaccinations tables

select * from portfolioProject..covidDeaths
where continent is not null
Order by 3,4

select * from portfolioProject..covidVaccinations
Order by 3,4

 

select location, date, total_cases, new_cases, new_deaths, Population
from PortfolioProject.dbo.CovidDeaths
order by 1,2


  
--Looking total cases vs total deaths

 select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage
 from PortfolioProject..CovidDeaths
 where location like '%india%' or location like '%canada%' or location like '%states%'
 order by 1,2
 

   
-- Looking total cases vs population
-- percentage of population got covid

 select location, date, total_cases, population, (total_cases/population)*100 as percentage
 from PortfolioProject..CovidDeaths
 where location like '%india%' or location like '%canada%' or location like '%states%'
 order by 1,2

-- Looking at countries highest infection rate compared to population

select location, date, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentpopulationinfected
from portfolioproject..coviddeaths
--where location like '%india%' or location like '%canada%' or location like'%states%'
group by location, population, date 
order by percentpopulationinfected desc

--showing countries with highest death count  per population

select location, max(cast(total_deaths as int)) as totaldeathscount
from portfolioproject..coviddeaths
--where location like '%india%' or locaiton like '%canada%' or location like '%states%'
where continent is not null
group by location
order by totaldeathscount

--by continent

--showing continent with highest death count per population

select continent, max(cast(total_deaths as int)) as totaldeathscount
from portfolioproject..coviddeaths
--where location like '%india%' or location like '%canada%' or location like '%states%'
where continent is not null
group by continent
order by totaldeathscount desc

--global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/
  sum(new_cases)*100 as deathpercentage
from portfolioproject..coviddeaths
--where location like '%india%'
where continent is not null
--group by date
order by 1,2

--select total population vs vaccinations

select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--use cte

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null)

select *, (rollingpeoplevaccinated/population)*100
from  popvsvac





--temp table

drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255), location nvarchar(255), date datetime, population numeric,
new_vaccinations numeric, rollingpeoplevaccinated numeric

)

insert into #percentpopulationvaccinated
select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date)as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select*,(rollingpeoplevaccinated/population)*100
from  #percentpopulationvaccinated


