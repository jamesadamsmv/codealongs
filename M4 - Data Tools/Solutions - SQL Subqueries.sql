-- What was the average track popularity
-- from artists in the pop genre?

SELECT AVG(popularity)
FROM
  (SELECT b.genre, AVG(a.track_popularity) AS popularity
  FROM "alastairtyson/multiverse_music_streaming"."tracks" a
  INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" b
    ON a.artist=b.artist_id
  WHERE b.genre like '%pop%'
  GROUP BY b.artist_name, b.genre) AS pop_by_genre;

-- note: do what’s in parens first, then select avg(popularity)

-- Which tracks are shorter than average?

SELECT track_name, length
FROM "alastairtyson/multiverse_music_streaming"."tracks"
WHERE length <
  (SELECT AVG(length)
  FROM "alastairtyson/multiverse_music_streaming"."tracks");

-- List the streams that came from artists
-- more popular than Taylor Swift?

SELECT b.track_name, c.artist_name
FROM "alastairtyson/multiverse_music_streaming"."plays" a
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
  ON a.song_id=b.id
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" c
  ON b.artist=c.artist_id
WHERE CAST(c.artist_popularity AS INT) > 
  (SELECT CAST(artist_popularity AS INT)
    FROM "alastairtyson/multiverse_music_streaming"."artists"
    WHERE artist_name = 'Taylor Swift');

*-- show taylor swift query first*


-- What percentage of the streams did
-- Drake receive on the 27th October?

SELECT SUM(b.number_plays)/(SELECT SUM(number_plays) FROM "alastairtyson/multiverse_music_streaming"."plays") *100 AS Drake_percentage
FROM "alastairtyson/multiverse_music_streaming"."tracks" a
INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" b
  ON a.id=b.song_id
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" c
  ON a.artist=c.artist_id
WHERE c.artist_name ='Drake';

-- Compared to the rest of the world, how many
-- plays came from North America on the 27th October?

SELECT location, count(*)
FROM 
  (SELECT *,
  CASE
    WHEN country IN ('USA','Canada','Mexico') THEN 'North America'
    ELSE 'Rest of World'
    END AS location
  FROM "alastairtyson/multiverse_music_streaming"."users" a
  INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" b
    ON a.user_id=b.user) AS location_table
GROUP BY location;

-- *show parens first*

-- ==================== --
-- Independent Practice --
-- ==================== --


-- What was the average number of
-- followers from artists in the rock genre?

SELECT AVG(followers)
FROM
  (SELECT b.genre, AVG(b.followers) AS followers
  FROM "alastairtyson/multiverse_music_streaming"."tracks" a
  INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" b
    ON a.artist=b.artist_id
  WHERE b.genre like '%rock%'
  GROUP BY b.artist_name, b.genre) AS followers_by_genre;

-- How many artists have more
-- than 10 explicit songs?

SELECT COUNT(*)
FROM
  (SELECT b.artist_name, COUNT(*) AS number_explicit_songs
  FROM "alastairtyson/multiverse_music_streaming"."tracks" a
  INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" b
    ON a.artist=b.artist_id
  WHERE a.explicit is True
  GROUP BY b.artist_name
  HAVING COUNT(*) > 10
  ORDER BY 2 DESC) AS explicit_artists;
 
-- Which pop songs were from artists
-- with above average popularity?

SELECT artist_name, artist_popularity
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE CAST(artist_popularity AS INT)>
  (SELECT AVG(CAST(artist_popularity AS INT))
  FROM "alastairtyson/multiverse_music_streaming"."artists" );

-- What percentage of users are in the USA?

SELECT CAST(COUNT(*) AS FLOAT)/(SELECT COUNT(*) FROM "alastairtyson/multiverse_music_streaming"."users") *100
FROM "alastairtyson/multiverse_music_streaming"."users"
WHERE country='USA';

-- Which 5 artists had the highest
-- share of the plays on the 27th October?

SELECT c.artist_name,SUM(b.number_plays)/(SELECT SUM(number_plays) FROM "alastairtyson/multiverse_music_streaming"."plays") *100
FROM "alastairtyson/multiverse_music_streaming"."tracks" a
INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" b
  ON a.id=b.song_id
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" c
  ON a.artist=c.artist_id
GROUP BY c.artist_name
ORDER BY 2 DESC
LIMIT 5;

-- How many children (under 16) listened
-- to explicit songs on the 27th October?

SELECT COUNT(*)
FROM
  (SELECT username, COUNT(*)
  FROM
    (SELECT *,
    CASE
      WHEN dob >'2005-10-27' THEN 'Child'
      ELSE 'Adult'
      END AS age_category
    FROM "alastairtyson/multiverse_music_streaming"."users" a
    INNER JOIN "alastairtyson/multiverse_music_streaming"."plays"       ON a.user_id=b.user
    INNER JOIN  "alastairtyson/multiverse_music_streaming"."tracks" c
      ON b.song_id=c.id
    WHERE c.explicit=True) AS explicit_listens
  WHERE age_category='Child'
  GROUP BY username,dob) AS child_explicit_listens;
 


-- For UK listeners, compare the number of
-- streams for morning (6am-noon), afternoon(noon-5pm),
-- evening(5pm-8pm) and night. 

SELECT time_period, COUNT(*)
FROM
  (SELECT *, 
  CASE
    WHEN EXTRACT(HOUR FROM CAST(a.first_played AS time)) >=20 THEN 'Night'
    WHEN EXTRACT(HOUR FROM CAST(a.first_played AS time)) >=17 THEN 'Evening'
    WHEN EXTRACT(HOUR FROM CAST(a.first_played AS time)) >=12 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM CAST(a.first_played AS time)) >=6 THEN 'Morning'
    ELSE 'NIGHT' 
  END AS time_period
  FROM "alastairtyson/multiverse_music_streaming"."plays" a
  INNER JOIN "alastairtyson/multiverse_music_streaming"."users" b
    ON a.user=b.user_id
  INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" c
    ON a.song_id=c.id
  INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" d
    ON c.artist=d.artist_id
  WHERE b.country='UK') AS time_listens
GROUP BY time_period;
 

-- Which artists have more than
-- 50% of their songs as explicit?

SELECT t.artist,CAST(t.number_explicit_songs AS FLOAT)/s.number_songs AS proportion_explicit
FROM
  (SELECT a.artist_name, COUNT(*) AS number_songs
  FROM "alastairtyson/multiverse_music_streaming"."artists" a
  INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
    ON a.artist_id=b.artist
  GROUP BY a.artist_name) AS s
RIGHT JOIN
  (SELECT a.artist_name AS artist, COUNT(*) AS number_explicit_songs
  FROM "alastairtyson/multiverse_music_streaming"."artists" a
  INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
    ON a.artist_id=b.artist
  WHERE b.explicit=True
  GROUP BY a.artist_name) as t
  ON s.artist_name=t.artist
WHERE CAST(t.number_explicit_songs AS FLOAT)/s.number_songs > 0.5;

-- A song is considered ‘long’ if it is over
-- 5 minutes long. Which 5 artists have the most ‘long’ songs?

SELECT artist_name, COUNT(*) AS number_of_songs
FROM
 
(SELECT b.artist_name,a.track_name, a.length,
CASE
  WHEN a.length > 300000 THEN 'Long'
  ELSE 'Short'
END AS length_category
FROM "alastairtyson/multiverse_music_streaming"."tracks" a
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" b
  ON a.artist=b.artist_id) AS lengths
WHERE length_category='Long'
GROUP BY artist_name
ORDER BY 2 DESC
LIMIT 5;
 

-- [Stretchiest of Stretch questions]
-- What was the most popular artist (by number of
-- streams) per country on the 27th October?

SELECT max_plays_per_country.country, max_plays_per_country_and_artist.artist_name, max_plays_per_country.max_plays
FROM 
  (SELECT d.country, b.artist_name, SUM(c.number_plays) AS number_of_plays
  FROM "alastairtyson/multiverse_music_streaming".tracks AS a 
  INNER JOIN "alastairtyson/multiverse_music_streaming".artists AS b 
    ON a.artist = b.artist_id 
  INNER JOIN "alastairtyson/multiverse_music_streaming".plays AS c 
    ON a.id = c.song_id 
  INNER JOIN "alastairtyson/multiverse_music_streaming".users AS d 
    ON c."user" = d.user_id 
  GROUP BY d.country,b.artist_name) AS max_plays_per_country_and_artist
INNER JOIN
  (SELECT DISTINCT(country), MAX(number_of_plays) AS max_plays
  FROM
    (SELECT d.country, b.artist_name, SUM(c.number_plays) AS number_of_plays
  FROM "alastairtyson/multiverse_music_streaming".tracks AS a 
  INNER JOIN "alastairtyson/multiverse_music_streaming".artists AS b 
    ON a.artist = b.artist_id 
  INNER JOIN "alastairtyson/multiverse_music_streaming".plays AS c 
    ON a.id = c.song_id 
  INNER JOIN "alastairtyson/multiverse_music_streaming".users AS d 
    ON c."user" = d.user_id 
  GROUP BY d.country,b.artist_name) AS max_plays_per_country_and_artist
  GROUP BY country
  ) AS max_plays_per_country
ON max_plays_per_country_and_artist.country = max_plays_per_country.country
    AND max_plays_per_country_and_artist.number_of_plays=max_plays_per_country.max_plays;
 
 
-- Independent Practice  
-- Below are the questions with answers for the independent practice. 
 
-- Apprentices will work on a brief in breakout rooms together.
-- Before going into the groups, do a walkthrough on how to identify
-- the problem in the brief, what data they need to solve the problem,
-- and what questions they would create to write queries for. 

-- You will develop questions as a cohort and in their groups they will write the queries themselves. 

-- NOTE: If your apprentices are struggling with writing a query,
-- do a walkthrough of writing a query for one of the questions identified. 

-- Problem: What types of documentaries are performing best?
-- Outcomes: Identify which general theme should you commission for to be in English? 
-- Actions: We need to identify English spoken documentaries and aggregate their review scores.
-- Data: A dataset containing Netflix’s shows and review scores 
-- Questions to query: 
--   What are the documentaries that are in English?
--   What are the highest rated English documentaries? 
--   What are the general themes of the highest rated English documentaries?

-- To perform the queries: 
--   We need to look at the Genre and three review scores columns and combine them into a subquery
--   From there we can look at the different specific genres. 

-- Note: a useful function to show is SPLIT_PART(string, delimiter, position) to split apart the genre string. SPLIT_PART("Genre",',',2) will return the second genre mentioned in that field.

SELECT SPLIT_PART("Genre",',',2) AS secondary_genre, AVG(IMDb)
FROM
  (SELECT "Genre","Series or Movie", AVG("IMDb Score") AS IMDb, AVG("Rotten Tomatoes Score") AS RT, AVG("Metacritic Score") AS MC
  FROM "bitdotio/Latest_complete_Netflix_movie_dataset_created_from_4_A"."netflix-rotten-tomatoes-metacritic-imdb/"
  WHERE "Genre" LIKE '%Documentary%' AND "Languages" LIKE '%English%' AND "IMDb Score" IS NOT NULL
  GROUP BY "Genre", "Series or Movie") AS genre_scores

GROUP BY secondary_genre
ORDER BY 2 DESC
LIMIT 5;
