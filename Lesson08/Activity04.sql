-- Open PostgreSQL and connect to the sqlda database

$ psql sqlda

-- Determine a list of customers (customer_id, first name, last name) who had been sent an email, including the subject of the email and if they opened and clicked on the email. The resulting table should include the columns customer_id, first_name, last_name, email_subject, opened, clicked

sqlda=# SELECT customers.customer_id, customers.first_name, customers.last_name, emails.opened, emails.clicked FROM customers INNER JOIN emails ON customers.customer_id=emails.customer_id;

-- Save the resulting table to a new table customer_emails

sqlda=# SELECT customers.customer_id, customers.first_name, customers.last_name, emails.opened, emails.clicked INTO customer_emails FROM customers INNER JOIN emails ON customers.customer_id=emails.customer_id; 

-- Find those customers who opened or clicked on an email

SELECT * FROM customer_emails WHERE clicked='t' and opened='t';

-- Find the customers who have a dealership in their city; customers who do not have a dealership in their city should have a blank value for the city field

sqlda=# SELECT customers.customer_id, customers.first_name, customers.last_name, customers.city FROM customers LEFT JOIN dealerships on customers.city=dealerships.city;

-- Save these results to a table called customer_dealers

sqlda=# SELECT customers.customer_id, customers.first_name, customers.last_name, customers.city INTO customer_dealers FROM customers LEFT JOIN dealerships on customers.city=dealerships.city;

-- List those customers who do not have dealers in their city (hint a blank field is NULL

sqlda=# SELECT * from customer_dealers WHERE city is NULL;