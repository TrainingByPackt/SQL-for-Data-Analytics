-- Drop all existing indexes using the DROP INDEX command

DROP INDEX <index name>; 

-- Using EXPLAIN and ANALYZE, but without using a hash index

sqlda=# EXPLAIN ANALYZE SELECT * FROM customers WHERE gender='M';

--Create a B-Tree index on the gender column and repeat the query to determine the performance using the default index

sqlda=# CREATE INDEX ix_gender ON customers USING btree(gender);

-- Repeat the following query at least 5 times manually and observe the time estimates after each execution

sqlda=# EXPLAIN ANALYZE SELECT * FROM customers WHERE gender='M';

-- Drop or remove the index
 
sqlda=# DROP INDEX ix_gender;

-- Create a hash index on the gender column

sqlda=# CREATE INDEX ix_gender ON customers USING HASH(gender);

-- Repeat the query from step 4 to check the execution time

sqlda=# EXPLAIN ANALYZE SELECT * FROM customers WHERE gender='M';

-- Use the EXPLAIN ANALYZE command to profile the performance of the query that selects all customers where the state is FO

sqlda=# EXPLAIN ANALYZE SELECT * FROM customers WHERE state='FO';

-- Create a B-Tree index on the state column of customers and repeat the query profiling

sqlda=# CREATE INDEX ix_state ON customers USING BTREE(state);
sqlda=# EXPLAIN ANALYZE SELECT * FROM customers WHERE state='FO';

-- Drop the ix_state B-Tree index and create a hash scan

sqlda=# DROP INDEX ix_state;
sqlda=# CREATE INDEX ix_state ON customers USING HASH(state);

-- EXPLAIN and ANALYZE to profile the performance of the hash scan

sqlda=# EXPLAIN ANALYZE SELECT * FROM customers WHERE state='FO';










