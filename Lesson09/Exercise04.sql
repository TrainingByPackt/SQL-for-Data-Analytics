-- Load the sqlda database:

$ psql sqlda

-- Firstly, look at the emails table to see what information is available. Select the first 5 rows of the emails table

sqlda=# SELECT * FROM emails LIMIT 5;

-- Determine the case we need to collect the customer_id from both the emails table and the bat_sales table for the Bat Scooter, the opened, sent_date, opened_date, and email_subject columns from emails as well as sales_transaction_date from the bat_sales table. As we only want the email records from the customers who purchased a bat scooter, we will join on equal customer_id in both tables. Insert the results into a new table bat_emails

sqlda=# SELECT emails.email_subject, emails.customer_id, emails.opened, emails.sent_date, emails.opened_date, bat_sales.sales_transaction_date INTO bat_emails FROM emails INNER JOIN bat_sales ON bat_sales.customer_id=emails.customer_id ORDER BY bat_sales.sales_transaction_date;

-- Select the first 10 rows of the bat_emails table, ordering the results by sales_transaction_date

sqlda=# SELECT * FROM bat_emails LIMIT 10;

-- Select all rows where the email sent_date predates the sales_transaction_date, order by the customer_id and limit the output to the first 22 rows

sqlda=# SELECT * FROM bat_emails WHERE sent_date < sales_transaction_date ORDER BY customer_id LIMIT 22;

-- Delete the rows where the bat_emails table which was sent before the 6-month mark prior to production

sqlda=# DELETE FROM bat_emails WHERE sent_date < '2016-04-10';

-- Delete the rows where the sent date is after the purchase date as they are not relevant to the sale

sqlda=# DELETE FROM bat_emails WHERE sent_date > sales_transaction_date;

-- Delete those rows where the difference between the transaction date and sent date exceeds 30, as we also only want those emails which were sent reasonably shortly before the scooter purchase

sqlda=# DELETE FROM bat_emails WHERE (sales_transaction_date-sent_date) > '30 days';

-- Examine the first 22 rows again ordered by customer_id by running the following query

sqlda=# SELECT * FROM bat_emails ORDER BY customer_id LIMIT 22;

-- Select the distinct value from the email_subject column to get a list of the different emails sent to the customers

sqlda=# SELECT DISTINCT(email_subject) FROM bat_emails;

-- Delete all records which have Black Friday in the email subject. These emails do not seem relevant to the sale of the Bat Scooter

sqlda=# DELETE FROM bat_emails WHERE position('Black Friday' in email_subject)>0;

-- Delete all rows where 25% off all EVs. It's a Christmas Miracle! and A New Year, And Some New EVs is in the email subject

sqlda=# DELETE FROM bat_emails WHERE position('25% off all EV' in email_subject)>0;
sqlda=# DELETE FROM bat_emails WHERE position('Some New EV' in email_subject)>0;

-- At this stage, we have our final dataset of emails sent to customers. Count the number of rows that are left in the sample by writing the following query

sqlda=# SELECT count(sales_transaction_date) FROM bat_emails;

-- We will now compute the percentage of emails that were opened relative to sales. Count the emails were opened by writing the following query

sqlda=# SELECT count(opened) FROM bat_emails WHERE opened='t'

-- Count the customers who received emails and made a purchase. We will determine this by counting the number of unique (or distinct) customers that are in the bat_emails table

sqlda=# SELECT COUNT(DISTINCT(customer_id)) FROM bat_emails;

-- Count the unique (or distinct) customers that made a purchase, by writing the following query

sqlda=# SELECT COUNT(DISTINCT(customer_id)) FROM bat_sales;

-- Calculate the percentage of customers who purchased a bat scooter after receiving an email

sqlda=# SELECT 396.0/6659.0 AS email_rate;

-- Limit the scope of our data to be all sales prior to 1st November 2016 and put the data in a new table called bat_emails_threewks

sqlda=# SELECT * INTO bat_emails_threewks FROM bat_emails WHERE sales_transaction_date < '2016-11-01';

-- Count the number of emails sent during this period

sqlda=# SELECT COUNT(opened) FROM bat_emails_threewks;

-- Count the number of emails opened in the first three weeks

sqlda=# SELECT COUNT(opened) FROM bat_emails_threewks WHERE opened='t';

-- Count the number of customers who received emails during the first three weeks of sales made a purchase using the following query

sqlda=# SELECT COUNT(DISTINCT(customer_id)) FROM bat_emails_threewks;

-- Calculate the percentage of customers who opened emails about the bat scooter made a sale in the first three weeks using the following query

sqlda=# SELECT 15.0/82.0 AS sale_rate;

-- Calculate how many unique customers we have in total throughout the first three weeks

sqlda=# SELECT COUNT(DISTINCT(customer_id)) FROM bat_sales WHERE sales_transaction_date < '2016-11-01';
