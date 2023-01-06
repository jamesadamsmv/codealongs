-- Exploring the data and interface - how do the tables relate? How do we query it?
-- What types of data are in our table?

-- Code formatting: add comments to your code by starting a line with --
-- And end a SQL block with a semi-colon to break up your queries ;

-- Select columns from a table and limit results with SELECT and LIMIT
SELECT album_name, no_tracks
FROM "alastairtyson/multiverse_music_streaming"."albums";

-- Select ALL columns from a table and limit results with SELECT *
SELECT *
FROM "alastairtyson/multiverse_music_streaming"."albums"
LIMIT 10;

-- Select only unique values within a column with DISTINCT(col)
SELECT DISTINCT(genre), artist_id
FROM "alastairtyson/multiverse_music_streaming"."artists"
LIMIT 100;

-- Select countries col from users and order with ORDER BY col
SELECT username, country
FROM "alastairtyson/multiverse_music_streaming"."users"
ORDER BY country
LIMIT 100;

-- ... And change to descending order with ORDER BY col DESC
SELECT username, country
FROM "alastairtyson/multiverse_music_streaming"."users"
ORDER BY country, username DESC
LIMIT 100;

-- Filter the genre column in artists for a certain genre with WHERE genre='pop rap'
SELECT *
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE genre = 'pop rap'
LIMIT 100;

-- Filter by multiple WHERE clauses with AND
SELECT *
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE genre = 'pop rap' AND followers > 300000
LIMIT 100;

SELECT *
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE genre = 'pop rap' OR genre = 'pop'
LIMIT 100;

-- And for all pop-related genres with LIKE and ILIKE rather than = and wildcards %
SELECT *
FROM "alastairtyson/multiverse_music_streaming"."artists"
WHERE genre ILIKE '%pop%'
LIMIT 100;

-- Group artists by genre with GROUP BY col and count with COUNT(genre) and rename cols with AS
SELECT genre, COUNT(genre) AS no_of_artists
FROM "alastairtyson/multiverse_music_streaming"."artists"
GROUP BY genre
ORDER BY no_of_artists DESC
LIMIT 10;

-- -- And filter after a grouping with HAVING
SELECT genre, COUNT(genre) AS no_of_artists
FROM "alastairtyson/multiverse_music_streaming"."artists"
GROUP BY genre
HAVING COUNT(genre) > 20
ORDER BY no_of_artists DESC
LIMIT 100;

-- -- Mathematical operators and CAST for changing data types
SELECT artist_popularity, followers, CAST(artist_popularity as bigint) + followers AS new_number
FROM "alastairtyson/multiverse_music_streaming"."artists"
LIMIT 10;

-- Extract aspects of a date from users dob field with WHERE EXTRACT(YEAR FROM dob)
SELECT dob, EXTRACT(YEAR from dob) AS year_born
FROM "alastairtyson/multiverse_music_streaming"."users"
LIMIT 10;

-- ... and filter the results with WHERE EXTRACT(YEAR FROM dob) < year
SELECT dob, EXTRACT(YEAR from dob) AS year_born
FROM "alastairtyson/multiverse_music_streaming"."users"
WHERE EXTRACT(YEAR from dob) >= 2000 -- returns anyone born in or after the year 2000
LIMIT 10;

-- And use NOW() and EXTRACT(YEAR) in SELECT to calculate ages
SELECT dob, EXTRACT(YEAR from NOW()) - EXTRACT(YEAR from dob) AS age
FROM "alastairtyson/multiverse_music_streaming"."users"
LIMIT 10;