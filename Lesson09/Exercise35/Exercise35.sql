-- Load the sqlda database

$ psql sqlda

-- List the available fields in the sales database

sqlda=# \d

-- Use an inner join on the product_id columns of both the product_names table and the sales table. From the result of the inner join select the model, customer_id, sales_transaction_date, sales_amount, channel, and dealership_id and store the values in a separate table called product_sales

sqlda=# SELECT model, customer_id, sales_transaction_date, sales_amount, channel, dealership_id INTO products_sales FROM sales INNER JOIN product_names ON sales.product_id=product_names.product_id;

-- Look at the first 5 rows of this new table by using the following query

sqlda=# SELECT * FROM products_sales LIMIT 5;

-- Select all information from the product_sales table that is available for the Bat scooter and orders the sales information by sales_transaction_date in ascending order

sqlda=# SELECT * FROM products_sales WHERE model='Bat' ORDER BY sales_transaction_date;

-- Count the number of records available by using the following query

sqlda=# SELECT COUNT(model) FROM products_sales WHERE model='Bat';

-- Determine the last sale date for the Bat scooter by selecting the maximum (using the MAX function) for sales_transaction_date

sqlda=# SELECT MAX(sales_transaction_date) FROM products_sales WHERE model='Bat';

-- Collect the daily sales volume for the Bat scooter and place it into a new table called bat_sales. to confirm the information provided by the sales team stating that sales dropped by 20% after the first two weeks
 
sqlda=# SELECT * INTO bat_sales FROM products_sales WHERE model='Bat' ORDER BY sales_transaction_date;

-- Remove the time information to allow tracking of sales by the date we will, as at this stage we are not interested in the time at which each sale occurred. To do so run the following query

sqlda=# UPDATE bat_sales SET sales_transaction_date=DATE(sales_transaction_date);

-- Display the first 5 records of bat_sales ordering by sales_transaction_date

sqlda=# SELECT * FROM bat_sales ORDER BY sales_transaction_date LIMIT 5;

-- Create a new table (bat_sales_daily) containing the sales transaction dates and a daily count of total sales

sqlda=# SELECT sales_transaction_date, COUNT(sales_transaction_date) INTO bat_sales_daily FROM bat_sales GROUP BY sales_transaction_date ORDER BY sales_transaction_date;

-- Examine the first 22 records (a little over 3 weeks), as sales were reported to have dropped after approximately the first 2 weeks

sqlda=# SELECT * FROM bat_sales_daily LIMIT 22;