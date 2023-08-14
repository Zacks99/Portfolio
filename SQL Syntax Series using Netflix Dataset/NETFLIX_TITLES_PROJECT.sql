SELECT * FROM netflix;

-- COUNT THE NUMBER OF MOVIES AND TV SHOWS 
SELECT TYPE,COUNT(*) AS COUNT 
FROM netflix 
GROUP BY TYPE ;

-- count the occurance oF directors 
select DIRECTOR , COUNT(*) AS DIRECTOR_COUNT
FROM netflix
GROUP BY director
ORDER BY 2 DESC; 

-- COUNT THE NUMBER OF TITLES FROM EACH COUNTRY(COUNTRY OF THE MOST TITLES ) 
SELECT COUNTRY , COUNT(*) AS TITLES_FROM_COUNTRY 
FROM netflix
GROUP BY country 
ORDER BY 2 DESC;

-- COUNT THE NUMBER OF TITLES IN EACH GENRE 
SELECT LISTED_IN ,COUNT(*) AS COUNT
FROM netflix
GROUP BY listed_in 
ORDER BY 2 DESC;

-- COUNT THE NUMBER OF TITLES IN EACCH RATING 
SELECT RATING ,COUNT(*) AS RATING_COUNT 
FROM netflix
GROUP BY rating 
ORDER BY 2 DESC ;

-- COUNT THE DURATION OF EACH TITLE 
SELECT TYPE , AVG(cast(REPLACE(DURATION,'MIN','') AS SIGNED INTEGER )) AS AVG_DURATION_MINUTES
FROM netflix
GROUP BY TYPE;

-- COUNT THE NUMBER OF TITELES ADDED EACH YEAR 
SELECT release_year ,COUNT(*) AS TITELES_ADED 
FROM netflix
GROUP BY release_year
ORDER BY 2 DESC;

-- Count the number of titles added each month/year and calculate the cumulative count over time
SELECT
    DATE_FORMAT(date_added, '%Y-%m') AS month_year,
    COUNT(*) AS count,SUM(COUNT(*)) OVER (ORDER BY DATE_FORMAT(date_added, '%Y-%m')) AS cumulative_count
FROM
    netflix
GROUP BY
    DATE_FORMAT(date_added, '%Y-%m')
ORDER BY 1; 

-- Find the countries with the most diverse content (highest number of unique genres)
SELECT*FROM netflix;
SELECT COUNTRY ,COUNT(DISTINCT LISTED_IN)AS UNIQUE_GENRES
FROM netflix
GROUP BY country
ORDER BY 2 DESC;

-- Find similar titles based on shared genres (for a specific title)
SELECT
    t1.title AS title1,
    t2.title AS title2,
    COUNT(DISTINCT t1.listed_in) AS common_genres
FROM
    netflix t1
JOIN
    netflix t2
    ON t1.title != t2.title -- Ensure we don't compare a title with itself
    AND t1.listed_in = t2.listed_in -- Join on common genres
WHERE
    t1.title = 'Grown Ups' -- Replace with the title you want to analyze
GROUP BY
    t1.title,
    t2.title
HAVING
    common_genres > 0
ORDER BY
    common_genres DESC;
SELECT * FROM netflix;

-- Find the top countries with the most titles for each genre
SELECT
    listed_in,
    country,
    COUNT(*) AS count
FROM
    netflix
GROUP BY
    listed_in,
    country
HAVING
    COUNT(*) > 4
ORDER BY
    listed_in,
    count DESC;
    
-- Find the longest movie and TV show for each genre
SELECT
    type,
    listed_in,
    title,
    duration
FROM
    netflix
WHERE
    (type = 'Movie' OR type = 'TV Show') -- Ensure only movies and TV shows are included
    AND duration = (
        SELECT MAX(duration)
        FROM netflix t2
        WHERE t2.type = netflix.type AND t2.listed_in = netflix.listed_in
    );
    