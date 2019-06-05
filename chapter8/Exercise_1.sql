/* Exercise SQL Query Planning */
\echo Printing Simple Query Plan
EXPLAIN SELECT * FROM emails;

\echo Limit Simple Query Plan 
EXPLAIN SELECT * FROM emails LIMIT 5;

\echo Query Plan Between Dates 
EXPLAIN SELECT * FROM emails WHERE clicked_date BETWEEN '2011-01-01' AND '2011-02-01'; 
