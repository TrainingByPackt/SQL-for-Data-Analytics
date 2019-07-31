-- Open PostgreSQL and connect to the sqlda database

C:\> psql sqlda

-- Use the EXPLAIN command to return the query plan for selecting all available records within the customers table

Sqlda=# EXPLAIN SELECT * FROM customers;

-- Repeat the query from step 2 of this exercise, this time limiting the number of returned records to 15

Sqlda=# EXPLAIN SELECT * FROM customers LIMIT 15;

-- Generate the query plan, selecting all rows where customers live within a latitude of 30 and 40 degrees

Sqlda=# EXPLAIN SELECT * FROM customers WHERE latitude > 30 and latitude < 40;