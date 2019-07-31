-- Open PostgreSQL and connect to the sqlda database

C:\> psql sqlda

-- Query plan of emails table

sqlda=# EXPLAIN SELECT * FROM emails;

-- Query plan the emails table with the limit set as 5

sqlda=# EXPLAIN SELECT * FROM emails LIMIT 5;

-- Search for dates between two specific values in the field clicked_date

sqlda=# EXPLAIN SELECT * FROM emails WHERE clicked_date BETWEEN '2011-01-01' and '2011-02-01';


