---- M4: Data Tools SQL: Day 1 ----
---- Stretch questions ----

-- Rows to recycle ----
-- "alastairtyson/multiverse_music_streaming"."albums"
-- "alastairtyson/multiverse_music_streaming"."artists"
-- "alastairtyson/multiverse_music_streaming"."new plays"
-- "alastairtyson/multiverse_music_streaming"."plays"
-- "alastairtyson/multiverse_music_streaming"."tracks"
-- "alastairtyson/multiverse_music_streaming"."users"

-- Q1: How many streams came from tracks that were ---------------------------------------------------------------------------------------------------------------------
-- from an album with more than 10 tracks? 
-- Answer: 654,454 plays

SELECT SUM(pl.number_plays)
FROM "alastairtyson/multiverse_music_streaming"."plays"  AS pl
JOIN "alastairtyson/multiverse_music_streaming"."tracks" AS tr
    ON pl.song_id = tr.id
JOIN "alastairtyson/multiverse_music_streaming"."albums" AS al
    ON tr.album = al.album_id
WHERE al.no_tracks > 10;

-- Q2. What was the average track length of songs streamed from the UK? ---------------------------------------------------------------------------------------------------
-- Answer: In ms: 206162.85, in mins: 2.93

SELECT AVG(tr.length) AS avg_track_length
FROM  "alastairtyson/multiverse_music_streaming"."tracks" tr
JOIN "alastairtyson/multiverse_music_streaming"."plays"   pl
    ON tr.id = pl.song_id
JOIN "alastairtyson/multiverse_music_streaming"."users"   us
    ON pl.user = us.user_id
WHERE us.country = 'UK';

-- Q3. How many artists have a number in their name? ---------------------------------------------------------------------------------------------------------------------
-- (A few different solutions provided - great to suggest to those with more experience with SQL!)
-- Answer: 28

-- 3.1. 
SELECT SUM(
    CASE
        WHEN artist_name LIKE '%0%' THEN 1
        WHEN artist_name LIKE '%1%' THEN 1
        WHEN artist_name LIKE '%2%' THEN 1
        WHEN artist_name LIKE '%3%' THEN 1
        WHEN artist_name LIKE '%4%' THEN 1
        WHEN artist_name LIKE '%5%' THEN 1
        WHEN artist_name LIKE '%6%' THEN 1
        WHEN artist_name LIKE '%7%' THEN 1
        WHEN artist_name LIKE '%8%' THEN 1
        WHEN artist_name LIKE '%9%' THEN 1
        ELSE 0
    END
) -- end of SUM function
FROM "alastairtyson/multiverse_music_streaming"."artists";

-- 3.2. 
SELECT DISTINCT( COUNT(artist_name) )
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE      artist_name LIKE '%0%' 
        OR artist_name LIKE '%1%' 
        OR artist_name LIKE '%2%' 
        OR artist_name LIKE '%3%' 
        OR artist_name LIKE '%4%' 
        OR artist_name LIKE '%5%'
        OR artist_name LIKE '%6%' 
        OR artist_name LIKE '%7%' 
        OR artist_name LIKE '%8%' 
        OR artist_name LIKE '%9%';

-- 3.3. Or, using a wildcard range in a WHERE statement, although this doesn't seem to work in bit.io
SELECT COUNT(artist_name)
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE artist_name LIKE '%[0-9]%';

-- 3.4. 
SELECT DISTINCT( COUNT(artist_name) )
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE artist_name LIKE ANY (ARRAY['%1%', '%2%', '%3%', 
      '%4%','%5%', '%6%', '%7%', '%8%', '%9%']);

-- 3.5. 
SELECT DISTINCT( COUNT(artist_name) )
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE artist_name ~* '1|2|3|4|5|6|7|8|9';

-- 3.6
SELECT COUNT(DISTINCT artist_name) as numerical_artist_names
FROM "alastairtyson/multiverse_music_streaming"."artists" 
WHERE artist_name ~ '[0-9]';


-- Q4. Out of all artists with John in their name, ----------------------------------------------------------------------------------------------------------------------
-- who had the highest number of streams (from the plays table)?
-- Answer: John Legend, 1002 plays

SELECT ar.artist_name, 
       SUM(pl.number_plays) AS total_plays
FROM "alastairtyson/multiverse_music_streaming"."artists" ar
JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
    ON ar.artist_id = tr.artist
JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
    ON tr.id = pl.song_id
WHERE ar.artist_name ILIKE '%John%'
GROUP BY ar.artist_name
ORDER BY total_plays DESC;

-- Q5. Which 10 albums had the most streams in the plays table? ---------------------------------------------------------------------------------------------------------
-- Who were the artists? 
-- Top answer: Kanye West, 24399 plays, Donda

SELECT ar.artist_name, 
       al.album_name, 
       SUM(pl.number_plays) AS total_plays
FROM "alastairtyson/multiverse_music_streaming"."artists" ar
JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
    ON ar.artist_id = tr.artist
JOIN "alastairtyson/multiverse_music_streaming"."albums" al
    ON tr.album = al.album_id
JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
    ON tr.id = pl.song_id
GROUP BY al.album_name, ar.artist_name
ORDER BY total_plays DESC
LIMIT 10;

-- Q6. Which albums had the highest number of different songs streamed (all-time)? -------------------------------------------------------------------------------------
-- Answer: Donda, 31 different songs streamed, (Kanye West)

-- 6.1 without artist name
SELECT al.album_name, COUNT(tr.track_name) AS no_diff_songs
FROM "alastairtyson/multiverse_music_streaming"."albums" al
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
    ON al.album_id = tr.album
GROUP BY album_name
ORDER BY no_diff_songs DESC
LIMIT 10;

-- 6.2 with artist name
SELECT
    al.album_name,
    SUM(pl.number_plays) AS total_plays,
    COUNT( DISTINCT(tr.id) ) AS no_of_tracks
FROM "alastairtyson/multiverse_music_streaming"."tracks" tr
JOIN "alastairtyson/multiverse_music_streaming"."albums" al
    ON tr.album = al.album_id
JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
    ON tr.id = pl.song_id
GROUP BY al.album_name
ORDER BY no_of_tracks DESC;

-- 6.3 also with artist name
SELECT al.album_name, 
       ar.artist_name, 
       COUNT(tr.track_name) AS no_diff_songs
FROM "alastairtyson/multiverse_music_streaming"."albums" al
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
    ON al.album_id = tr.album
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" ar
    ON tr.artist = ar.artist_id
GROUP BY al.album_name, ar.artist_name
ORDER BY no_diff_songs DESC
LIMIT 10;
