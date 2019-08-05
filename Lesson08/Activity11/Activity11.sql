-- Use the EXPLAIN and ANALYZE commands to profile the query plan to search for all records with an IP address of 18.131.58.65

EXPLAIN ANALYZE SELECT * FROM customers WHERE ip_address = '18.131.58.65';

-- Create a generic index based on the IP address column

CREATE INDEX ON customers(ip_address);

-- Re-run the query of step 1 and note the time it takes to execute

EXPLAIN ANALYZE SELECT * FROM customers WHERE ip_address = '18.131.58.65';

-- Create a more tailed index based on the IP address column with condition that the IP address is 18.131.58.65

CREATE INDEX ix_ip_where ON customers(ip_address) WHERE ip_address = '18.131.58.65';

-- Re-run the query of step 1 and note the time it takes to execute

EXPLAIN ANALYZE SELECT * FROM customers WHERE ip_address = '18.131.58.65';.

-- Use the EXPLAIN and ANALYZE commands to profile the query plan to search for all records with a suffix of 'Jr'

EXPLAIN ANALYZE SELECT * FROM customers WHERE suffix = 'Jr';

-- Create a generic index based on the suffix address column:

CREATE INDEX ix_jr ON customers(suffix);

-- Re-run the query of step 6 and note the time it takes to execute

EXPLAIN ANALYZE SELECT * FROM customers WHERE suffix = 'Jr';




