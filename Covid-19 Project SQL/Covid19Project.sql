SELECT 
    *
FROM
    coviddeaths
ORDER BY 3 , 4;
-- looking at total cases vs total deaths 
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS death_precentage
FROM
    coviddeaths
WHERE
    location LIKE '%state%'
ORDER BY 1 , 2;

-- looking at the total cases vs population 
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS population_with_covid
FROM
    coviddeaths
WHERE
    location LIKE '%spain%'
ORDER BY 1 , 2;

-- looking at the countries with highest infection rate compared to population 
SELECT 
    location,
    population,
    MAX(total_cases) AS highest_infection,
    MAX(total_cases / population) * 100 AS population_with_covid
FROM
    coviddeaths
GROUP BY location , population
ORDER BY population_with_covid DESC;
-- convert type of total_death 
ALTER TABLE coviddeaths
MODIFY COLUMN total_deaths INT;
-- contries with highest death count population
SELECT 
    Location,
    MAX(CAST(Total_deaths AS SIGNED INT)) AS TotalDeathCount
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;
-- insted of countries we do continent 
SELECT 
    continent,
    MAX(CAST(Total_deaths AS SIGNED INT)) AS TotalDeathCount
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- new cases by date over the world 
SELECT 
    date, SUM(new_cases)
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY date
ORDER BY 1 , 2;

-- sum of the new deaths 
SELECT 
    date,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS deaths_percentage
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- join the deaths and vaccionation together

SELECT 
    *
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = dea.date;

-- looking at the total population vs total vaccinations 

SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY 1 , 2 , 3;

-- rolling peaople vaccionated 
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date) as rolling_people_vaccionated
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY 2,3;

-- we gonna use CTE to take the total of rolling_people_vaccionated

with population_vs_vaccionation (continent , location,date, population,new_vaccinations,rolling_people_vaccionated)
as (
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date) as rolling_people_vaccionated
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY 2,3
)
select *,(rolling_people_vaccionated/population)*100 as percentage_pf_people_vacionated 
from population_vs_vaccionation;


-- creat a view 
 create view percentage_pf_people_vacionated as 
 SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location ,dea.date) as rolling_people_vaccionated
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL;

select * from percentage_pf_people_vacionated