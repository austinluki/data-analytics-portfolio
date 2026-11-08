
# COVID-19 Data Exploration

I explored global COVID-19 data in SQL, then built a Tableau dashboard from the results. I wanted to see how the pandemic played out across countries and continents: how many people got infected, how many died, and how fast vaccinations rolled out.

**Dashboard:** [Add your Tableau Public link for this dashboard]

## Dataset

The data is the Our World in Data COVID-19 dataset, split into two tables:

- **Deaths:** 59 columns covering cases, deaths and population
- **Vaccinations:** 37 columns covering tests and vaccinations

Each table has 85,171 rows, one per location per day, from 1 January 2020 to 30 April 2021. It covers 210 countries and territories, plus extra rows for continents and world totals.

## Tools

Microsoft SQL Server, Excel and Tableau Public.

## Getting the data ready

- I imported both Excel files into SQL Server as `CovidDeaths` and `CovidVaccinations`.
- The data mixes countries with continent and world rows. For country queries I only kept rows where `continent` is not null. For continent totals I used the rows where it is null.
- The death and vaccination columns needed `CAST` to integers before I could add them up.

## What I looked at

- Total cases vs total deaths, which gives the death percentage (I did this one for Indonesia)
- Total cases vs population, which shows what share of people got infected
- Countries with the highest infection rate compared to population
- Countries and continents with the highest death counts
- Global totals and the overall death percentage
- A rolling count of vaccinations per country, using `SUM() OVER (PARTITION BY ... ORDER BY ...)` on a join of the two tables
- The same thing again with a CTE and a temp table, to get the percentage of the population vaccinated
- A view, so the results can be reused for visualizations

## What I found

- By 30 April 2021 the data shows 150,574,977 cases and 3,180,206 deaths worldwide, a death percentage of 2.11%.
- Deaths by continent: Europe (1,016,750), North America (847,942), South America (672,415), Asia (520,269), Africa (121,784) and Oceania (1,046).
- The countries with the most deaths were the United States (576,232), Brazil (403,781), Mexico (216,907), India (211,853) and the United Kingdom (127,775).
- Compared to population, the highest infection rates were in small European countries: Andorra (17.13%), Montenegro (15.51%), Czechia (15.23%), San Marino (14.93%) and Slovenia (11.56%).
- Indonesia had 1,668,368 cases and 45,521 deaths. Deaths were 2.73% of confirmed cases, higher than the global 2.11%. About 0.61% of the population had a confirmed infection.
- Vaccinations had barely started in Indonesia by the end of the data, with doses at about 4.5% of the population. Israel (121%) and Gibraltar (182%) were far ahead.

## Dashboard

I exported four result tables from SQL and used them in Tableau Public: global totals, deaths by continent, the percentage of each country's population infected, and how that percentage changed over time.

## Files

- `COVID PORTFOLIO PROJECT - SQL DATA EXPLORATION.sql`: all my SQL queries
- `CovidDeaths.xlsx` and `CovidVaccinations.xlsx`: the source data
- `Tableau_Table1.xlsx`, `Tableau_Table_2.xlsx`, `Tableau_Table_3.xlsx` and `Tableau_Table_4.xlsx`: the result tables I used in Tableau

## Notes

The cases and deaths are as reported, and the data stops on 30 April 2021. The numbers depend on how much testing each country did, so be careful when comparing countries. The vaccination figure counts doses, not people, so it can go over 100% when a country gave several doses per person.
