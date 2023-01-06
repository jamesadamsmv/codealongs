---- M4: Data Tools SQL: Day 1 ----
---- Stretch questions ----

-- Rows to recycle ----
-- "alastairtyson/multiverse_music_streaming"."albums"
-- "alastairtyson/multiverse_music_streaming"."artists"
-- "alastairtyson/multiverse_music_streaming"."new plays"
-- "alastairtyson/multiverse_music_streaming"."plays"
-- "alastairtyson/multiverse_music_streaming"."tracks"
-- "alastairtyson/multiverse_music_streaming"."users"

-- Q1: How many streams came from tracks that were 
-- from an album with more than 10 tracks?
SELECT SUM(pl.number_plays)
FROM "alastairtyson/multiverse_music_streaming"."plays" as pl
JOIN "alastairtyson/multiverse_music_streaming"."tracks" as tr
    ON pl.song_id = tr.id
JOIN "alastairtyson/multiverse_music_streaming"."albums" as al
    on tr.album = al.album_id
WHERE al.no_tracks > 10;

-- Q2. What was the average track length of songs streamed from the UK?
SELECT AVG(tr.length) as avg_track_length
FROM  "alastairtyson/multiverse_music_streaming"."tracks" tr
JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
    on tr.id = pl.song_id
JOIN "alastairtyson/multiverse_music_streaming"."users" us
    on pl.user = us.user_id
WHERE us.country = 'UK';

-- Q3. How many artists have a number in their name?
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

-- Or, using a wildcard range in a WHERE statement, although this doesn't seem to work in bit.io
SELECT COUNT(artist_name)
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE artist_name LIKE '%[0-9]%';

-- Q4. Out of all artists with John in their name, 
-- who had the highest number of streams (from the plays table)?
SELECT ar.artist_name, SUM(pl.number_plays) AS total_plays
FROM "alastairtyson/multiverse_music_streaming"."artists" ar
JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
    ON ar.artist_id = tr.artist
JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
    ON tr.id = pl.song_id
WHERE ar.artist_name LIKE '%John%'
GROUP BY ar.artist_name
ORDER BY total_plays DESC;

-- Q5. Which 10 albums had the most streams in the plays table? 
-- Who were the artists?
SELECT ar.artist_name, al.album_name, SUM(pl.number_plays) AS total_plays
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

-- Q6. Which albums had the highest number of different songs streamed (all-time)?
SELECT
    al.album_name,
    SUM(pl.number_plays) as total_plays,
    COUNT( DISTINCT(tr.id) ) as no_of_tracks
FROM "alastairtyson/multiverse_music_streaming"."tracks" tr
JOIN "alastairtyson/multiverse_music_streaming"."albums" al
    ON tr.album = al.album_id
JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
    ON tr.id = pl.song_id
GROUP BY al.album_name
ORDER BY no_of_tracks DESC;