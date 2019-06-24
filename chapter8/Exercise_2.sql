/*Index Scan*/
EXPLAIN SELECT * FROM customers WHERE state='FO';
EXPLAIN SELECT DISTINCT state FROM customers;
CREATE INDEX ix_state ON customers(state);
EXPLAIN SELECT * FROM customers WHERE state='FO';
EXPLAIN SELECT * FROM customers WHERE gender='M';
CREATE INDEX ix_state ON customers(gender);
\d customers;
EXPLAIN SELECT * FROM customers WHERE gender='M';
EXPLAIN SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);
CREATE INDEX ix_latitude ON customers(latitude);
EXPLAIN ANALYZE SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);

