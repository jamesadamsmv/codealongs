---- DF M4: Data Tools - SQL (Day 1) ----
---- CASE Guided practice ----

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


-- 2. Create a label for artists followers > 5mil (large), 
-- 3-5 (medium), 1-3 small, <1 tiny 
-- (think about the importance of putting the conditions in order).


-- 3. Find the average popularity for each label


---- CASE in ORDER ----

-- 1. Order tracks by their album popularity, 
-- if it is a single then use its track popularity instead.


---- Independent practice ----

-- 1a. Apply the label ‘pop’ if an an artist’s genre contains pop, 
-- ‘rap’ if it contains rap, ‘rock’ if it contains rap, 
-- ‘dance’ if it contains dance and ‘other’ if anything else


-- 1b. How many artists fall in each category?


-- 2a. Label a track as long if over 3 minutes, 
-- average if between 1 and 3 minutes and short otherwise


-- 2b. How many songs fall into each category? 
-- Order the songs in each category by length


-- 3a. If a track has both track_popularity and artist_popularity > 90
-- label it ‘Supremely Popular’, 
-- if track is >90 but artist is not label it overperforming, 
-- if track <90 but artist>90 label it underperforming 
-- and if both <90 label it not popular. 


-- 3b. What is the average followers for each category, 
-- rounded to 1 dp?


-- 4. Label anyone who didn’t listen to any tracks on the 27th October 
-- as ‘inactive’, otherwise ‘active. 
-- Return all the full names of the inactive users


-- 5a. If a user is under 16, label them as ‘child’ 
-- otherwise they are an adult
-- Compare the total number of plays for children and adults 
-- on the 27th October


-- 5b. From users labelled children, 
-- what were the top 5 artists streamed on the 27th October?


-- 6. [Stretch] For UK listeners find the number of plays 
-- for morning (6am-noon), afternoon(noon-5pm), evening(5pm-8pm)
--  and night. 
