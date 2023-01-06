-- Exploring the data and interface - how do the tables relate? How do we query it?
-- What types of data are in our table?
-- Code formatting, comments in the code and semi-colons to end a block of code


-- Select columns from a table and limit results with SELECT and LIMIT


-- Select ALL columns from a table and limit results with SELECT *


-- Select only unique values within a column with DISTINCT(col)


-- Select countries col from users and order with ORDER BY col


-- ... And change to descending order with ORDER BY col DESC


-- Filter the genre column in artists for a certain genre with WHERE genre='pop rap'


-- Filter by multiple WHERE clauses with AND


-- And for all pop-related genres with LIKE and ILIKE rather than = and wildcards %


-- Group artists by genre with GROUP BY col and count with COUNT(genre) and rename cols with AS


-- -- And filter after a grouping with HAVING


-- -- Mathematical operators and CAST for changing data types


-- Extract aspects of a date from users.dob with WHERE EXTRACT(YEAR FROM dob) < year


-- And use NOW() and EXTRACT(YEAR) in SELECT to calculate ages