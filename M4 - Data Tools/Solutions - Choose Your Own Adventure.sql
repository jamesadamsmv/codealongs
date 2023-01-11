-- ========= --
-- BRIEF ONE --
-- ========= --

-- You work for a music label and are looking for the next big star.
-- Investigate which 10 artists that have under 100000 followers
-- have seen the most plays on October 27.

SELECT c.artist_name,SUM(a.number_plays) as total_streams
FROM "alastairtyson/multiverse_music_streaming"."plays" a
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
    ON a.song_id=b.id
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" c
    ON b.artist=c.artist_id
WHERE c.followers<100000
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--  Which 3 countries listened to the most streamed
-- artist with less than 100000 followers on October 27?

SELECT d.country, SUM(a.number_plays) as total_streams
FROM "alastairtyson/multiverse_music_streaming"."plays" a
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
    ON a.song_id=b.id
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" c
    ON b.artist=c.artist_id
INNER JOIN "alastairtyson/multiverse_music_streaming"."users" d
    ON a.user=d.user_id
WHERE c.artist_name='Young Stoner Life'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;


-- Stretch: Investigate how to add in streams from
-- October 28 (you will need to research subqueries
-- and use UNION ALL)

SELECT artist_name, SUM(total_streams)
FROM
    (SELECT c.artist_name,SUM(a.number_plays) as total_streams
    FROM "alastairtyson/multiverse_music_streaming"."plays" a
    INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
        ON a.song_id=b.id
    INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" c
        ON b.artist=c.artist_id
    WHERE c.followers<100000
    GROUP BY 1
    UNION ALL
    SELECT c.artist_name,SUM(a.number_plays)
    FROM "alastairtyson/multiverse_music_streaming"."new_plays" a
    INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
        ON a.song_id=b.id
    INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" c
        ON b.artist=c.artist_id
    WHERE c.followers<100000
    GROUP BY 1) as streams
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- ========= --
-- BRIEF TWO --
-- ========= --


-- A music label is researching the optimal number of tracks to have
-- on an album. They would like you to compare the total streams of
-- songs from albums with less than or equal to  5 tracks, less than
-- or equal to 10 tracks and no upper limit.
-- Compare your results with the performance of single only tracks
-- to investigate if albums are even necessary. 

SELECT
    CASE
        WHEN a.no_tracks<=5 THEN '5_below'
        WHEN a.no_tracks <=10 THEN '10_below'
        ELSE 'no_limit'
    END as album_cat, SUM(c.number_plays) as total_streams
FROM "alastairtyson/multiverse_music_streaming"."albums" a
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
    ON a.album_id=b.album
INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" c
    ON b.id=c.song_id
GROUP BY 1
UNION
SELECT
    CASE
        WHEN d.is_single=true THEN 'single'
        ELSE 'not single'
    END as single, SUM(e.number_plays) as total_streams
FROM "alastairtyson/multiverse_music_streaming"."tracks" d
INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" e
    ON d.id=e.song_id
GROUP BY 1
HAVING SUM(e.number_plays)<700000
ORDER BY 2 DESC;


-- Stretch: Investigate how to add in streams from
-- October 28 (you will need to research subqueries and use UNION ALL)

SELECT streams.album_cat, SUM(streams.total_streams)
FROM
    ((SELECT
        CASE
            WHEN a.no_tracks<=5 THEN '5_below'
            WHEN a.no_tracks <=10 THEN '10_below'
            ELSE 'no_limit'
        END as album_cat, SUM(c.number_plays) as total_streams
    FROM "alastairtyson/multiverse_music_streaming"."albums" a
    INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
        ON a.album_id=b.album
    INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" c
        ON b.id=c.song_id
    GROUP BY 1
    UNION
    SELECT
        CASE
            WHEN d.is_single=true THEN 'single'
            ELSE 'not single'
        END as single, SUM(e.number_plays) as total_streams
    FROM "alastairtyson/multiverse_music_streaming"."tracks" d
    INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" e
        ON d.id=e.song_id
    GROUP BY 1
    HAVING SUM(e.number_plays)<700000
    ORDER BY 2 DESC)
    UNION ALL
    (SELECT
        CASE
            WHEN a.no_tracks<=5 THEN '5_below'
            WHEN a.no_tracks <=10 THEN '10_below'
            ELSE 'no_limit'
        END as album_cat, SUM(c.number_plays) as total_streams
    FROM "alastairtyson/multiverse_music_streaming"."albums" a
    INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" b
        ON a.album_id=b.album
    INNER JOIN "alastairtyson/multiverse_music_streaming"."new_plays" c
        ON b.id=c.song_id
    GROUP BY 1
    UNION
    SELECT
        CASE
            WHEN d.is_single=true THEN 'single'
            ELSE 'not single'
        END as single, SUM(e.number_plays) as total_streams
    FROM "alastairtyson/multiverse_music_streaming"."tracks" d
    INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" e
        ON d.id=e.song_id
    GROUP BY 1
    HAVING SUM(e.number_plays)<700000
    ORDER BY 2 DESC)) as streams
GROUP BY 1
ORDER BY 2 DESC;
