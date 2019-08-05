-- Use the EXPLAIN and ANALYZE command to determine the planning time and cost as well as the execution time and cost to select all rows where the email subject is Shocking Holiday Savings On Electric Scooters

EXPLAIN ANALYZE SELECT * FROM emails where email_subject='Shocking Holiday Savings On Electric Scooters';

-- Use the EXPLAIN and ANALYZE command to determine the planning time and cost as well as the execution time and cost to select all rows where the email subject is Black Friday. Green Cars

EXPLAIN ANALYZE SELECT * FROM emails where email_subject='Black Friday. Green Cars.';

-- Create a hash scan on the email subject field

CREATE INDEX ix_email_subject ON emails USING HASH(email_subject);

-- Repeat step 1 from solution and compare both the outputs

EXPLAIN ANALYZE SELECT * FROM emails where email_subject='Shocking Holiday Savings On Electric Scooters';

-- Repeat step 2 from solution and compare both the outputs

EXPLAIN ANALYZE SELECT * FROM emails where email_subject='Black Friday. Green Cars.';

-- Create a hash scan on the customer_id field

CREATE INDEX ix_customer_id ON emails USING HASH(customer_id);

-- Use EXPLAIN and ANALYZE to estimate how long it would take to select all rows with a customer id value greater than 100

EXPLAIN ANALYZE SELECT * FROM emails WHERE customer_id > 100;

