-- 1. Count the number of Movies vs TV Shows

/*
SELECT type,count(type) FROM netflix
GROUP BY type
*/

-- 2. Find the most common rating for movies and TV shows

/*
select * from(
select *,row_number()over(partition by type order by rating_no desc) as row_no from
(select type,rating,count(rating) as rating_no
from netflix
group by 1,2
order by 3 desc)
order by row_no desc
)where row_no=1
*/

-- 3. List all movies released in a specific year (e.g., 2020)

/*
SELECT type,title,release_year FROM netflix
WHERE release_year = 2020 AND type='Movie'
*/

-- 4. Find the top 5 countries with the most content on Netflix

/*
select 
unnest(string_to_array(country,', ')) as country_name,count('show_id') as netflix_content from netflix
group by 1
order by 2 desc
limit 5
*/

-- 5. Identify the longest movie

--Using substring

/*
select type,title, cast(substring(duration, 1,position ('m' in duration)-1) as int) duration
from Netflix
where type = 'Movie' and duration is not null
order by 3 desc
limit 1
*/

--using split_apart

/*
SELECT  type,title, duration
FROM netflix
WHERE type = 'Movie' and duration is not null
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
limit 1
*/


-- 6. Find content added in the last 5 years

/*
select * from netflix
where to_date(date_added,('month DD,yyyy'))>=current_date-interval '5 years'
*/

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

--Using Subquery
--string_to_array

/*
select * from
(select type,title,unnest(string_to_array(director,','))as director
from netflix)
where director ='Rajiv Chilaka'
*/

--Using Subquery
--split_part

/*
select * from
(select type,title,split_part(director,',',1) as director
from netflix)
where director ='Rajiv Chilaka'
*/

--Using ilike
/*
select * from netflix
where director ilike '%Rajiv Chilaka%'
*/


-- 8. List all TV shows with more than 5 seasons

/*
SELECT * FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5
*/


-- 9. Count the number of content items in each genre
/*
select
unnest(string_to_array(listed_in,', ')) as genre,
count(type)
from netflix
group by 1
*/

-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
/*
select 
extract(year from to_date(date_added,'month dd,yyyy'))as year,
count(show_id) as total_release,
count(show_id)/(select count(show_id) from netflix where country ilike '%India%')::numeric*100
from netflix
where country ilike '%India%'
group by 1
order by 2 desc
*/

-- 11. List all movies that are documentaries

--Method1
/*
select * from
(select type,title,
unnest(string_to_array(listed_in,',')) as movie_genre
from netflix
where type='Movie')
where movie_genre ilike '%Documentaries%'
*/

--Method2
/*
select * from netflix
where listed_in ilike '%Documentaries%'
*/

-- 12. Find all content without a director
/*
select * from netflix
where director is null
*/


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
/*
select * from netflix
where casts ilike '%Salman Khan%'
and release_year>extract(year from current_date)-10
*/


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

--Method1
/*
select movie_cast,count(movie_cast) from(
select type,
unnest(string_to_array(casts,',')) as movie_cast
from netflix
where type='Movie' and country ilike '%India%')
group by 1 order by 2 desc
*/

--Method2

/*
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country ilike '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
*/


--Question 15:
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

/*
select category,type,count(category)as content_count from
(select *,
case 
when description ilike '%Kill%' or description ilike '%Violence%' then 'BAD'
else 'GOOD'
end as category 
from netflix)
group by 1,2
order by 2
*/

