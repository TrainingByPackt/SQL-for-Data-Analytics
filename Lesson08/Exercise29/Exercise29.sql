-- Create a database called smalljoins in the PostgreSQL server

$ createdb smalljoins

-- Load the smalljoins.dump file 

$psql smalljoins < smalljoins.dump

-- Open the database

$ psql smalljoins

-- Inspect the information available for customers

smalljoins=# SELECT * FROM customers;

-- Inspect the information available for the order information

smalljoins=# SELECT * FROM order_info;

-- Execute an inner join where we retrieve all columns from both tables without duplicating the customer_id column

smalljoins=# SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty FROM customers INNER JOIN order_info ON customers.customer_id=order_info.customer_id;

-- Save the results of this query as a separate table, by inserting the INTO table_name keywords

smalljoins=# SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty INTO join_results FROM customers INNER JOIN order_info ON customers.customer_id=order_info.customer_id;

-- Use EXPLAIN ANALYZE to get an estimate of the time taken to execute the join

smalljoins=# EXPLAIN ANALYZE SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty FROM customers INNER JOIN order_info ON customers.customer_id=order_info.customer_id;

-- Select all of the customer_id that are in order_info and use EXPLAIN ANALYZE to find out.

smalljoins=# EXPLAIN ANALYZE SELECT * FROM customers WHERE customer_id IN (SELECT customer_id FROM order_info);

-- Execute a left join using the customers table as the left table and the order_info as the right table

smalljoins=# SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty FROM customers LEFT JOIN order_info ON customers.customer_id=order_info.customer_id;

-- Use EXPLAIN ANALYZE to determine the time and cost of executing the join

smalljoins=# EXPLAIN ANALYZE SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty FROM customers LEFT JOIN order_info ON customers.customer_id=order_info.customer_id;

-- Replace the left join of step 11 with a right join and observe the results

smalljoins=# EXPLAIN ANALYZE SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty FROM customers RIGHT JOIN order_info ON customers.customer_id=order_info.customer_id;

-- Use EXPLAIN ANALYZE to determine the time and cost of then right join

smalljoins=# EXPLAIN ANALYZE SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty FROM customers RIGHT JOIN order_info ON customers.customer_id=order_info.customer_id;

-- Insert an additional row into order_info with a customer_id that is not present in the customers table

smalljoins=# INSERT INTO order_info (order_id, customer_id, product_code, qty) VALUES (1621, 6, 'MEL386', 1);

-- Replace the left join of step 11 with a full outer join and observe the results

smalljoins=# SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty FROM customers FULL OUTER JOIN order_info ON customers.customer_id=order_info.customer_id;

-- Use the EXPLAIN ANALYZE command to determine the performance of the query

smalljoins=# EXPLAIN ANALYZE SELECT customers.*, order_info.order_id, order_info.product_code, order_info.qty FROM customers FULL OUTER JOIN order_info ON customers.customer_id=order_info.customer_id;










