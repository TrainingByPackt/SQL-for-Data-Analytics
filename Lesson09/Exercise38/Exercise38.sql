-- Load the sqlda database

$ psql sqlda

-- Drop the existing lemon_sales table

sqlda=# DROP TABLE lemon_sales;

-- The 2013 Lemon Scooter is product_id = 3. Select customer_id and sales_transaction_date from the sales table for the 2013 Lemon Scooter. Insert the information into a table called lemon_sales

sqlda=# SELECT customer_id, sales_transaction_date INTO lemon_sales FROM sales WHERE product_id=3;

-- Select all information from the emails database for customers who purchased a 2013 Lemon Scooter. Place the information into a new table called lemon_emails

sqlda=# SELECT emails.customer_id, emails.email_subject, emails.opened, emails.sent_date, emails.opened_date, lemon_sales.sales_transaction_date INTO lemon_emails FROM emails INNER JOIN lemon_sales ON emails.customer_id=lemon_sales.customer_id;

-- Remove all emails sent before the start of production for the 2013 Lemon Scooter. For that first we will get the start of the production date

sqlda=# SELECT production_start_date FROM products Where product_id=3;

-- Now, delete the emails that were sent before the start of production for the 2013 Lemon Scooter

sqlda=# DELETE FROM lemon_emails WHERE sent_date < '2013-05-01';

-- Remove all rows where the sent date occurred after the sales_transaction_date

sqlda=# DELETE FROM lemon_emails WHERE sent_date > sales_transaction_date;

-- Remove all rows where the sent date occurred more than 30 days before the sales_transaction_date

sqlda=# DELETE FROM lemon_emails WHERE (sales_transaction_date - sent_date) > '30 days';

-- Remove all rows from lemon_emails where the email subject is not related to a Lemon Scooter. Before doing this we will search for all distinct emails

sqlda=# SELECT DISTINCT(email_subject) FROM lemon_emails;

-- Now, delete the email subject not related to Lemon scooter using DELETE command

sqlda=# DELETE FROM lemon_emails WHERE POSITION('25% off all EVs.' in email_subject)>0;
sqlda=# DELETE FROM lemon_emails WHERE POSITION('Like a Bat out of Heaven' in email_subject)>0;
sqlda=# DELETE FROM lemon_emails WHERE POSITION('Save the Planet' in email_subject)>0;
sqlda=# DELETE FROM lemon_emails WHERE POSITION('An Electric Car' in email_subject)>0;
sqlda=# DELETE FROM lemon_emails WHERE POSITION('We cut you a deal' in email_subject)>0;
sqlda=# DELETE FROM lemon_emails WHERE POSITION('Black Friday. Green Cars.' in email_subject)>0;
sqlda=# DELETE FROM lemon_emails WHERE POSITION('Zoom' in email_subject)>0;

-- Check how many emails of lemon_scooter customers were opened?

sqlda=# SELECT COUNT(opened) FROM lemon_emails WHERE opened='t';

-- List the number of customers who received emails and made a purchase

sqlda=# SELECT COUNT(DISTINCT(customer_id)) FROM lemon_emails;

-- Calculate the percentage of customers who opened the received emails and made a purchase

sqlda=# SELECT 128.0/506.0 AS email_rate;

-- Calculate the number of unique customers who made a purchase

sqlda=# SELECT COUNT(DISTINCT(customer_id)) FROM lemon_sales;

-- Calculate the percentage of customers who made a purchase received an email. This will allow us to compare to the corresponding figure for the Bat Scooter

sqlda=# SELECT 506.0/13854.0 AS email_sales;

-- Select all records from lemon_emails where a sale occurred within the first three weeks of the start of production. Store the results in a new table lemon_emails_threewks

sqlda=# SELECT * INTO lemon_emails_threewks FROM lemon_emails WHERE sales_transaction_date < '2013-06-01';

-- How many emails were made for Lemon Scooters in the first three weeks?

sqlda=# SELECT COUNT(sales_transaction_date) FROM lemon_emails_threewks;