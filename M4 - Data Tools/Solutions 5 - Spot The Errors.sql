-- Spot the Errors


--1
SELECT country, SUM(number_plays) AS total_streams
FROM "alastairtyson/multiverse_music_streaming"."users" a
INNER JOIN "alastairtyson/multiverse_music_streaming"."new_plays" b
  ON a.user_id = b.user_id
GROUP BY a.country
ORDER BY 2
;


--2
SELECT artist_name, artist_popularity
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE artist_name LIKE '%z%'
ORDER BY 2 DESC
LIMIT 1
;


--3
SELECT track_name, all_time_streams
FROM "alastairtyson/multiverse_music_streaming"."tracks"
WHERE explicit=True
ORDER BY 2
LIMIT 1
;


--4
SELECT a.track_name, SUM(b.number_plays)
FROM "alastairtyson/multiverse_music_streaming"."tracks" a
RIGHT JOIN "alastairtyson/multiverse_music_streaming"."plays" b
  ON a.id=b.song_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
;


--5
SELECT country, SUM(number_plays)
FROM "alastairtyson/multiverse_music_streaming"."users" us
INNER JOIN "alastairtyson/multiverse_music_streaming"."plays" pl
ON us.user_id=pl.user
WHERE LENGTH(CONCAT(first_name,last_name))<10
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
;


--6
SELECT ar.artist_name, SUM(pl.number_plays) as total_streams
FROM "alastairtyson/multiverse_music_streaming"."plays" pl
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
  ON pl.song_id=tr.id
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" ar
  ON tr.artist=ar.artist_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
;


--7
SELECT ar.artist_name, SUM(pl.number_plays) as total_streams
FROM "alastairtyson/multiverse_music_streaming"."plays" pl
INNER JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
  ON pl.song_id=tr.id
INNER JOIN "alastairtyson/multiverse_music_streaming"."artists" ar
  ON tr.artist=ar.artist_id
WHERE CAST(ar.artist_popularity as bigint)<60
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
;


--8
SELECT COUNT(*) as num_tracks
FROM "alastairtyson/multiverse_music_streaming"."albums" al
RIGHT JOIN "alastairtyson/multiverse_music_streaming"."tracks" tr
  ON al.album_id=tr.album
;