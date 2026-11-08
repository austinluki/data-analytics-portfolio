# Netflix Content Analysis

I wanted to see what Netflix's catalog is made of: how much is Movies vs TV shows, where the content comes from, which genres and ratings are the most common, and how fast titles get added after they're released.

**Dashboards:** [View on Tableau Public](https://public.tableau.com/app/profile/austin.austin5429/vizzes)

## Dataset

8,807 titles (6,131 movies and 2,676 TV shows) with 12 columns: show ID, type, title, director, cast, country, release year, rating, duration, genre, description and the date the title was added to Netflix.

## Tools

MySQL, DBeaver and Tableau Public.

## Data cleaning

- The `date_added` column was stored as text (like "September 25, 2021") with extra spaces. I trimmed it and converted it to a proper `DATE` with `STR_TO_DATE`, then removed the old column.
- 10 titles have no date added. I kept them in the table and left them out of the date-based queries.
- 3 rows had a duration like "74 min" in the `rating` column. I left those out of the rating analysis.
- Director, country and cast have a lot of blanks. I counted them and filtered them out when they affected a result.
- Country, genre, director and cast have several values in one cell, separated by commas. I split them into one row per value so each one is counted properly, then exported each result as its own file for Tableau.

## Analysis

I wrote around 20 queries, starting with simple counts and moving on to harder ones:

- `GROUP BY`, `HAVING` and `ORDER BY` for counts by type, year, rating and director
- `LIKE` to find genres inside the comma-separated text
- `CASE` to group ratings into Adult, Teen and Kids and Family, and to group release gaps into buckets
- `LEFT`, `LOCATE`, `REPLACE`, `SUBSTRING` and `CAST` to pull movie minutes and season counts out of the duration text
- Subqueries for percentages and above-average comparisons
- CTEs and window functions for a rolling total of titles added per month and a ranking of ratings within each type

## What I found

- About 70% of the catalog is movies (6,131) and 30% is TV shows (2,676).
- Titles added per year peaked in 2019 at 2,016, then dropped in 2020 and 2021. Movies dropped more than TV shows.
- The United States has the most titles at 3,690, then India (1,046) and the United Kingdom (806).
- The most common genres are International Movies (2,752), Dramas (2,427) and Comedies (1,674).
- TV-MA is the most common rating at 3,207 titles. Adult content (4,009) is the biggest audience group, ahead of Teen (2,650) and Kids and Family (2,058).
- Most titles get added quickly. 3,241 were added in the same year they were released, and 2,299 more within one or two years. 14 were added before their listed release year.
- Most movies are around 90 to 110 minutes long. Two thirds of TV shows (1,793 of 2,676) have only one season.
- Rajiv Chilaka is the most credited director with 22 titles, and Anupam Kher is the most credited actor with 43.

## Dashboards

I made two dashboards in Tableau Public.

- **Overview:** summary numbers, titles added over time, a world map of content by country and the top genres.
- **Details:** breakdowns by type, rating, audience group, release gap, movie length, number of seasons, and the top countries, directors and actors.

## Files

- `data_exploration.sql`: all my SQL queries
- `netflix_clean.csv`: the cleaned data I used in Tableau
- `dashboard_overview.png` and `dashboard_details.png`: screenshots of the dashboards

## Notes

A title with several countries, genres, directors or actors is counted once under each one, so those totals add up to more than the number of titles. Tableau Public can't connect to MySQL directly, so I exported the cleaned table to CSV for the dashboards.
