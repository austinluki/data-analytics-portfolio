-- netflix_db data cleaning

-- remove duplicates

select *
from netflix_clean nc;

create table netflix_clean
like netflix_title;

insert netflix_clean 
select *
from netflix_title;

select *, 
row_number() over(
partition by show_id, `type`, title, director, `cast`, country, date_added, release_year, rating, duration, listed_in, description)
from netflix_clean;

with duplicate_cte as 
(
select *, 
row_number() over(
partition by `type`, title, director, `cast`, country, date_added, release_year, rating, duration, listed_in, description) as row_num
from netflix_clean
)
select *
from duplicate_cte
where row_num > 1;

	-- CLEAN NO DUPLICATES

-- Date Format Change

select *
from netflix_clean nc;

SELECT date_added,
      STR_TO_DATE(TRIM(date_added), '%M %d, %Y') AS date_added_clean
FROM netflix_clean;

alter table netflix_clean
add column date_added_clean DATE;

SELECT
  COUNT(*) AS total_rows,
  SUM(date_added_clean IS NULL) AS null_count
FROM netflix_clean;

update netflix_clean nc 
set date_added_clean = STR_TO_DATE(TRIM(date_added), '%M %d, %Y');

-- remove columns

select date_added
from netflix_clean;

alter table netflix_clean
drop column date_added;

alter table netflix_clean
rename column date_added_clean to date_added;

select * 
from netflix_clean;

select count(*) as total_rows,
count(distinct show_id) as unique_ids
from netflix_clean;

