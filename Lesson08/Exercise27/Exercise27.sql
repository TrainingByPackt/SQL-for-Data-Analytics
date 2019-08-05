-- Open PostgreSQL and connect to the sqlda database

C:\> psql sqlda

-- Starting with the customers database use the EXPLAIN command to determine the cost and number of rows in selecting all of the entries with a state value of FO

sqlda=# EXPLAIN SELECT * FROM customers WHERE state='FO';

-- Determine how many unique state values there are, again using the EXPLAIN command

sqlda=# EXPLAIN SELECT DISTINCT state FROM customers;

-- Create an index called ix_state using the state column of customers;

sqlda=# CREATE INDEX ix_state ON customers(state);

-- Re-run the EXPLAIN statement 

sqlda=# EXPLAIN SELECT * FROM customers WHERE state='FO';

-- Use the EXPLAIN command to return the query plan for a search for all records of males within the database

sqlda=# EXPLAIN SELECT * FROM customers WHERE gender='M';

-- Create an index called ix_gender using the gender column of customers.

sqlda=# CREATE INDEX ix_state ON customers(gender);

-- Confirm the presence of the index using \d

\d customers;

-- Re-run the EXPLAIN statement

sqlda=# EXPLAIN SELECT * FROM customers WHERE gender='M';

-- Use EXPLAIN to return the query plan, searching for latitudes less than 38 degrees and greater than 30 degrees

sqlda=# EXPLAIN SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);

-- Create an index called ix_latitude using the latitude column of customers

sqlda=# CREATE INDEX ix_latitude ON customers(latitude);

-- Use EXPLAIN to return the query plan, searching for latitudes less than 38 degrees and greater than 30 degrees and observe the output

sqlda=# EXPLAIN SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);

-- Use EXPLAIN ANALYZE to query plan the content of customers table with latitude between 30 and 38

sqlda=# EXPLAIN ANALYZE SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);

-- Create another index which includes the search criteria on customers table

sqlda=# CREATE INDEX ix_latitude_less ON customers(latitude) WHERE (latitude < 38) and (latitude > 30); 

-- Use EXPLAIN ANALYZE to query plan the content of customers table with latitude between 30 and 38, observe the output

sqlda=# EXPLAIN ANALYZE SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);



