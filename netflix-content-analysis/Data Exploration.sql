---------------------------------------------------------------------------------------------------------

-- 1. Total titles

select *
from netflix_db.netflix_clean;

select count(*) as total_title
from netflix_db.netflix_clean;

-- 2. Total movies and tv shows

select `type`, count(*) as total
from netflix_db.netflix_clean
group by `type`;

-- 3. Titles added to Netflix each year

select year(date_added) as year_added, count(*) as total_title
from netflix_db.netflix_clean
where date_added is not null
group by year_added
order by year_added desc;

-- 4. release years that have the most titles

select release_year, count(*) as total_title
from netflix_db.netflix_clean
group by release_year
order by total_title desc
limit 5;

-- 5. Titles per rating

select rating, count(*) as total_title
from netflix_db.netflix_clean
where rating is not null 
	and rating not like '%min'
group by rating
order by total_title desc;

-- 6. Titles added in each year-month

select substring(date_added, 1, 7) as `month`, count(*) as total
from netflix_db.netflix_clean
group by `month`
order by `month` desc;

-- 7. Movies and TV shows added each year

select year(date_added) as year_added,`type`, count(*)
from netflix_db.netflix_clean
where year(date_added) is not null
group by year_added, `type`
order by `type`;

-- 8. Titles no director listed 

select count(*) as no_director
from netflix_db.netflix_clean
where director is null or director = '';

-- 9. Ratings with more than 500 titles

select rating, count(*) as total_title
from netflix_db.netflix_clean
group by rating
having total_title > 500
order by total_title desc;

-- 10. Directors that have more than 10 titles

select director, count(*) as total_title
from netflix_db.netflix_clean
where director is not null and director != ''
group by director
having total_title > 10
order by total_title desc;

-- 11. Titles from the United States and in 'documentaries' genre

select count(*) as us_only
from netflix_db.netflix_clean
where country = 'United States';

select count(*) as documentaries
from netflix_db.netflix_clean
where listed_in like '%Documentaries%';

-- 12. Years passed between release and being added to Netflix and titles fall at each gap

select year(date_added) - release_year as gap_years, 
		count(*) as total
from netflix_db.netflix_clean
where date_added is not null
group by gap_years
order by gap_years;

-- 13. Share of titles that is Adult, Teen, or Kids & Family

select case
		when rating in ('TV-MA', 'R', 'NC-17') then 'Adult'
		when rating in ('TV-14', 'PG-13') then 'Teen'
		when rating in ('TV-PG', 'PG', 'TV-Y7', 'TV-Y7-FV', 'TV-Y', 'TV-G', 'G') then 'Kids & Family'
		else 'Other'
end as audience,
count(*) as total
from netflix_db.netflix_clean
group by audience
order by total desc;

-- 14. Shortest, longest and average (movies)
select min(minutes) as shortest,
		max(minutes) as longest,
		round(avg(minutes), 1) as average
from
(
select cast(replace(duration, ' min', '') as unsigned) as minutes
from netflix_db.netflix_clean
where type = 'movie' and duration like '%min'
) as movie_minutes;

-- 15. missing values in each row (director, country, cast)

select sum(case when director is null or director = '' then 1 else 0 end) as director_missing,
		sum(case when country is null or country = '' then 1 else 0 end) as country_missing,
		sum(case when `cast` is null or `cast` = '' then 1 else 0 end) as cast_missing
from netflix_db.netflix_clean;

-- 16. Release years that have more titles than the average release year

with yearly as
(
select release_year, count(*) as total
from netflix_db.netflix_clean
group by release_year
)
select *
from yearly
where total > (select avg(total) from yearly)
order by release_year asc;

-- 17. Percentage of each type of titles (Movie, TV Show)

select `type`, count(*),
		round(count(*)*100 / (select count(*) from netflix_db.netflix_clean), 1) as pct
from netflix_db.netflix_clean
group by `type`;

-- 18. Rolling total of titles added per year-month

with monthly as
(
select SUBSTRING(date_added, 1, 7) as `month`, count(*) as total
from netflix_db.netflix_clean
where date_added is not null
group by `month`
order by `month` asc
)
select `month`, total, sum(total) over (order by `month`) as rolling_total
from monthly
group by `month`;

-- 19. Rank of the ratings within each type

with rating_counts as
(
select `type`, rating, count(*) as total
from netflix_db.netflix_clean
where rating is not null and rating not like '%min'
group by `type`, rating 
),
rating_ranked as 
(
select *,
		dense_rank() over (partition by `type` order by total desc) as ranking
from rating_counts
)
select * 
from rating_ranked
where ranking <= 3
order by `type`, ranking;

---------------------------------------------------------------------------------------------------------

-- Country 

select n.show_id, n.`type`, trim(j.director) as director
from netflix_db.netflix_clean n,
     json_table(
         concat('["', replace(n.director, ',', '","'), '"]'),
         '$[*]' columns (director varchar(100) path '$')
     ) j
where n.director is not null
  and trim(n.director) <> ''
  and trim(j.director) <> '';

-- Genres

select n.show_id, n.`type`, trim(j.genre) as genre
from netflix_db.netflix_clean n,
     json_table(
         concat('["', replace(n.listed_in, ',', '","'), '"]'),
         '$[*]' columns (genre varchar(100) path '$')
     ) j
where n.listed_in is not null
  and trim(n.listed_in) <> ''
  and trim(j.genre) <> '';

-- Directors

select n.show_id, n.`type`, trim(j.director) as director
from netflix_db.netflix_clean n,
     json_table(
         concat('["',
                replace(replace(replace(n.director, '\\', '\\\\'), '"', '\\"'), ',', '","'),
                '"]'),
         '$[*]' columns (director varchar(100) path '$')
     ) j
where n.director is not null
  and trim(n.director) <> ''
  and trim(j.director) <> '';

-- Actors

select n.show_id, n.`type`, trim(j.actor) as actor
from netflix_db.netflix_clean n,
     json_table(
         concat('["',
                replace(replace(replace(n.`cast`, '\\', '\\\\'), '"', '\\"'), ',', '","'),
                '"]'),
         '$[*]' columns (actor varchar(100) path '$')
     ) j
where n.`cast` is not null
  and trim(n.`cast`) <> ''
  and trim(j.actor) <> '';
