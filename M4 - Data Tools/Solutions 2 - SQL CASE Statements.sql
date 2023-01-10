---- DF M4: Data Tools - SQL (Day 1)     ----
---- CASE Guided practice with solutions ----

---- Rows to recycle
-- "alastairtyson/multiverse_music_streaming"."albums"
-- "alastairtyson/multiverse_music_streaming"."artists"
-- "alastairtyson/multiverse_music_streaming"."new plays"
-- "alastairtyson/multiverse_music_streaming"."plays"
-- "alastairtyson/multiverse_music_streaming"."tracks"
-- "alastairtyson/multiverse_music_streaming"."users"


---- CASE in SELECT ----

-- 1: Create a label for artists followers if 
-- more than 5 million followers (large) and the rest small

SELECT artist_name, followers,
CASE
  WHEN followers > 5000000 THEN 'Large Artist'
  ELSE 'Small Artist'
END AS artist_size
FROM "alastairtyson/multiverse_music_streaming"."artists"; 

-- 2. Create a label for artists followers > 5mil (large), 
-- 3-5 (medium), 1-3 small, <3 tiny 

SELECT artist_name, followers,
CASE
  WHEN followers > 5000000 THEN 'Large Artist'
  WHEN followers > 3000000 THEN 'Medium Artist'
  WHEN followers > 1000000 THEN 'Small Artist'
  ELSE 'Tiny Artist'
END AS artist_size
FROM "alastairtyson/multiverse_music_streaming" ."artists";
 
-- Does the order matter?
-- (think about the importance of putting the conditions in order).

-- 3. Find the average popularity for each label

SELECT  
CASE
  WHEN followers > 5000000 THEN 'Large Artist'
  WHEN followers > 3000000 THEN 'Medium Artist'
  WHEN followers > 1000000 THEN 'Small Artist'
  ELSE 'Tiny Artist'
END AS artist_size, AVG( CAST(artist_popularity AS INT) ) AS average_popularity
FROM "alastairtyson/multiverse_music_streaming"."artists" 
GROUP BY artist_size;


---- CASE in ORDER ----

-- 1. Order tracks by their album popularity, 
-- if it is a single then use its track popularity instead.

SELECT tr.track_name, al.album_popularity, tr.track_popularity
FROM "alastairtyson/multiverse_music_streaming"."tracks" tr
FULL OUTER JOIN "alastairtyson/multiverse_music_streaming"."albums" al
  ON tr.album=al.album_id
ORDER BY 
  (CASE 
      WHEN al.album_popularity IS NULL THEN tr.track_popularity
      ELSE al.album_popularity
   END) DESC;

---- Independent practice ----

-- 1a. Apply the label ‘pop’ if an an artist’s genre contains pop, 
-- ‘rap’ if it contains rap, ‘rock’ if it contains rap, 
-- ‘dance’ if it contains dance and ‘other’ if anything else

SELECT artist_name, genre,
CASE 
  WHEN genre LIKE '%pop%'   THEN 'pop'
  WHEN genre LIKE '%rap%'   THEN 'rap'
  WHEN genre LIKE '%rock%'  THEN 'rock'
  WHEN genre LIKE '%dance%' THEN 'dance'
  ELSE 'other'
END
FROM "alastairtyson/multiverse_music_streaming"."artists"; 


-- 1b. How many artists fall in each category?

SELECT 
CASE
  WHEN genre LIKE '%pop%'   THEN 'pop'
  WHEN genre LIKE '%rap%'   THEN 'rap'
  WHEN genre LIKE '%rock%'  THEN 'rock'
  WHEN genre LIKE '%dance%' THEN 'dance'
  ELSE 'other'
END AS main_genre, COUNT(*) AS no_of_artists
FROM "alastairtyson/multiverse_music_streaming"."artists" 
GROUP BY main_genre
ORDER BY no_of_artists DESC;

-- 2a. Label a track as long if over 3 minutes, 
-- average if between 1 and 3 minutes and short otherwise

SELECT track_name, length,
CASE
  WHEN length > 180000 THEN 'Long'
  WHEN length >  60000 THEN 'Average'
  ELSE 'Short'
END AS length_category
FROM "alastairtyson/multiverse_music_streaming"."tracks"; 

-- 2b. How many songs fall into each category? 
-- Order the songs in each category by length

SELECT 
CASE
  WHEN length > 300000 THEN 'Long'
  WHEN length >  60000 THEN 'Average'
  ELSE 'Short'
END AS length_category, COUNT(*)
FROM "alastairtyson/multiverse_music_streaming"."tracks" 
GROUP BY length_category;


-- 3a. If a track has both track_popularity and artist_popularity > 90
-- label it ‘Supremely Popular’, 
-- if track is >90 but artist is not label it 'Overperforming', 
-- if track <90 but artist>90 label it 'Underperforming' 
-- and if both <90 label it 'Not Popular'. 

SELECT tr.track_name, ar.artist_name,
CASE
  WHEN tr.track_popularity > 90 AND CAST(ar.artist_popularity AS INT) > 90 THEN 'Supremely Popular'
  WHEN tr.track_popularity > 90 AND CAST(ar.artist_popularity AS INT) < 90 THEN 'Overperforming'
  WHEN tr.track_popularity < 90 AND CAST(ar.artist_popularity AS INT) > 90 THEN 'Underperforming'
  ELSE 'Not Popular'
END AS song_performance
FROM "alastairtyson/multiverse_music_streaming"."tracks" tr
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" ar
  ON tr.artist = ar.artist_id;

-- 3b. What is the average followers for each category, 
-- rounded to 1 dp?

SELECT
CASE
  WHEN tr.track_popularity > 90 AND CAST(ar.artist_popularity AS INT) > 90 THEN 'Supremely Popular'
  WHEN tr.track_popularity > 90 AND CAST(ar.artist_popularity AS INT) < 90 THEN 'Overperforming'
  WHEN tr.track_popularity < 90 AND CAST(ar.artist_popularity AS INT) > 90 THEN 'Underperforming'
  ELSE 'Not Popular'
END AS song_performance, ROUND(AVG(ar.followers), 1) AS average_followers
FROM "alastairtyson/multiverse_music_streaming"."tracks" tr
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" ar
  ON tr.artist = ar.artist_id
GROUP BY song_performance;


-- 4. Label anyone who didn’t listen to any tracks on the 27th October 
-- as ‘inactive’, otherwise ‘active'. 
-- Return all the full names of the inactive users

SELECT CONCAT(us.first_name,' ', us.last_name),
CASE
  WHEN pl.song_id IS NULL THEN 'inactive'
  ELSE 'active'
END as active_status
FROM "alastairtyson/multiverse_music_streaming"."users" us
FULL OUTER JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
  ON us.user_id = pl.user
WHERE pl.song_id IS NULL;

-- 5a. If a user is under 16, label them as ‘child’ 
-- otherwise they are an adult
-- Compare the total number of plays for children and adults 
-- on the 27th October

SELECT 
CASE
  WHEN dob > '2005-10-27' THEN 'Child'
  ELSE 'Adult'
END AS age_category, SUM(number_plays) AS number_of_plays
FROM "alastairtyson/multiverse_music_streaming"."users" us
INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
  ON us.user_id = pl.user
GROUP BY age_category;


-- 5b. From users labelled children, 
-- what were the top 5 artists streamed on the 27th October?

SELECT 
    ar.artist_name,
    SUM(pl.number_plays) AS total_plays
FROM "alastairtyson/multiverse_music_streaming"."users" us
INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
  ON us.user_id = pl.user
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
  ON pl.song_id = tr.id
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" ar
  ON tr.artist = ar.artist_id
WHERE
    (CASE
        WHEN dob > '2005-10-27' THEN 'Child'
        ELSE 'Adult'
    END) = 'Child'
    AND CAST(pl.first_played AS date) = '2021-10-27'
GROUP BY ar.artist_name
ORDER BY total_plays DESC
LIMIT 5;

-- 6. [Stretch] For UK listeners find the number of plays 
-- for morning (6am-noon), afternoon(noon-5pm), evening(5pm-8pm)
-- and night. 

SELECT
    CASE
        WHEN EXTRACT(HOUR FROM CAST(pl.first_played as TIME)) + 1 <= 6  THEN 'Night'
        WHEN EXTRACT(HOUR FROM CAST(pl.first_played as TIME)) + 1 <= 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM CAST(pl.first_played as TIME)) + 1 <= 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM CAST(pl.first_played as TIME)) + 1 <= 20 THEN 'Evening'
        WHEN EXTRACT(HOUR FROM CAST(pl.first_played as TIME)) + 1 <= 24 THEN 'Night'
        ELSE 'Other'
    END AS time_played,
    SUM(pl.number_plays)
FROM "alastairtyson/multiverse_music_streaming"."plays" pl
LEFT JOIN "alastairtyson/multiverse_music_streaming"."users" us
    ON pl.user = us.user_id
WHERE us.country = 'UK'
GROUP BY time_played;