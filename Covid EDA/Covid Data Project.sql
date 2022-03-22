
-- Building Table Example
create table covid_deaths (
	iso_code varchar(10) null,
	continent varchar(20) null,
    "location" varchar(50) null,
    "date" varchar(8) null,
	population int4 null,
	total_cases int4 null,
	new_cases int4 null,
	new_cases_smoothed float8 null,
	total_deaths int4 null,
	new_deaths int4 null,
	new_deaths_smoothed int4 null,
	total_cases_per_million float8 null,
	new_cases_per_million float8 null,
	new_cases_smoothed_per_million float8 null,
	total_deaths_per_million float8 null,
	new_deaths_per_million float8 null,
	new_deaths_smoothed_per_million int4 null,
	reproduction_rate float8 null,
	icu_patients int8 null,
	icu_patients_per_million float8 null,
	hosp_patients int8 null,
	hosp_patients_per_million float8 null,
	weekly_icu_admissions int8 null,
	weekly_icu_admissions_per_million float8 null,
	weekly_hosp_admissions int8 null,
	weekly_hosp_admissions_per_million float8 null);
	
-- Overall Quick View
select location, date, total_cases, new_cases, total_deaths, population
from covid_deaths 
order by 1, 2; 


-- Total Cases vs. Deaths - United States 
select location, date, total_cases, total_deaths, ((total_deaths::float)/(total_cases::float))*100 as deaths_percentage
from covid_deaths
where location ilike '%states%'
order by total_cases; 


-- Infection Count vs Percent of Population Infected
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases::float)/(population::float))*100 as PercentPopulationInfected
from covid_deaths
where continent is not null
group by location, population
order by PercentPopulationInfected desc;

-- Countries with Highest Infection Percentage
select location, max(total_cases) as highest_infection_count, Max((total_cases::float)/(population::float))*100 as percent_population_infected
from covid_deaths
where (continent <> '') is TRUE
group by location
order by percent_population_infected desc; 


-- Countries with Highest Death Counts 
select location, max(total_deaths) as highest_deceased_count, Max((total_deaths::float)/(population::float))*100 as percent_population_deceased
from covid_deaths
where (continent <> '') is true 
group by location 
order by highest_deceased_count desc;


-- Case and Death Count by Continent 
select continent, max(total_cases) as cumulative_case_count, max(total_deaths) as cumulative_death_count
from covid_deaths
where (continent <> '') is true 
group by continent 
order by cumulative_case_count desc

-- Hopitalizations and ICU Patients by Continent 
select location, avg(hosp_patients) as avg_hosp, avg(icu_patients) as avg_icu
from covid_deaths
where (continent <> '') is true 
group by location
order by avg_icu desc; 


-- Global Numbers over Time
select date, sum(new_cases) as total_new_cases, sum(new_deaths) as total_new_deaths
from covid_deaths
group by date
order by total_new_cases asc; 


-- Total Population vs Vaccinations 
create view pop_vs_vac as ( 
select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as rolling_vaccination_count
from covid_deaths as d 
	join covid_vaccinations as v on d.location = v.location 
	and d.date = v.date 
where (d.continent <> '') is true
order by 2, 3)

-- cumulative case and death count by country (visualization) 
select location, continent, max(total_cases) as total_cases_max, max(total_deaths) as total_deaths_max
from covid_deaths 
where (continent <> '') is true 
group by "location", continent 
order by total_cases_max desc; 
