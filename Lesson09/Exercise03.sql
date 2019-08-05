-- Load the sqlda database

$ psql sqlda

-- Examine the other products in the database

sqlda=# SELECT * FROM products;

-- List all scooters from the products table, as we are only interested in comparing scooters

sqlda=# SELECT * FROM products WHERE product_type='scooter'; 

-- Select the first 5 rows of the sales database

sqlda=# SELECT * FROM sales LIMIT 5;

-- Select the model and sales_transaction_date columns from both the products and sales tables for the Limited-Edition Bat Scooter. Store the results in a table bat_ltd_sales, ordered by sales_transaction_date from earliest to latest date.

sqlda=# SELECT products.model, sales.sales_transaction_date INTO bat_ltd_sales FROM sales INNER JOIN products ON sales.product_id=products.product_id WHERE sales.product_id=8 ORDER BY sales.sales_transaction_date;

-- Select the first 5 lines of bat_ltd_sales, using the following query

sqlda=# SELECT * FROM bat_ltd_sales LIMIT 5;

-- Calculate the total number of sales for the Bat Limited Edition. We can check this by using the COUNT function

sqlda=# SELECT COUNT(model) FROM bat_ltd_sales;

-- Check the transaction details of the last Bat Limited Edition sale. We can check this by using the MAX function

sqlda=# SELECT MAX(sales_transaction_date) FROM bat_ltd_sales;

-- Adjust the table to cast the transaction date column as a date, discarding the time information. As with the original bat scooter, we are only interested in the date of the sale, not the date and time of the sale. Write the following query

sqlda=# ALTER TABLE bat_ltd_sales ALTER COLUMN sales_transaction_date TYPE date;

-- Again, select the first 5 records of bat_ltd_sales

sqlda=# SELECT * FROM bat_ltd_sales LIMIT 5;

-- Similarly, to the standard Bat Scooter create a count of sales on a daily basis. Insert the results into the table bat_ltd_sales_count by using the following query

sqlda=# SELECT sales_transaction_date, count(sales_transaction_date) INTO bat_ltd_sales_count FROM bat_ltd_sales GROUP BY sales_transaction_date ORDER BY sales_transaction_date;

-- List the sale count of all the "Bat Limited" products using the following query

sqlda=# SELECT * FROM bat_ltd_sales_count;

-- Compute the cumulative sum of the daily sales figures and insert the resulting table into bat_ltd_sales_growth

sqlda=# SELECT *, sum(count) OVER (ORDER BY sales_transaction_date) INTO bat_ltd_sales_growth FROM bat_ltd_sales_count;

-- Select the first 22 days of sales records from bat_ltd_sales_growth

sqlda=# SELECT * FROM bat_ltd_sales_growth LIMIT 22;

-- Compare this sales record to the one for the original Bat Scooter sales as shown in the image below

sqlda=# SELECT * FROM bat_sales_growth LIMIT 22;

-- Compute the seven-day lag for the sum column and insert the results into the table bat_ltd_sales_delay

sqlda=# SELECT *, lag(sum , 7) OVER (ORDER BY sales_transaction_date) INTO bat_ltd_sales_delay FROM bat_ltd_sales_growth;

-- Compute the sales growth for bat_ltd_sales_delay similarly that completed in Activity 1, Quantifying the Sales Drop. Label the column for the results of this calculation AS volume and store the resulting table in bat_ltd_sales_vol

sqlda=# SELECT *, (sum-lag)/lag AS volume INTO bat_ltd_sales_vol FROM bat_ltd_sales_delay;

-- Look at the first 22 records of sales in bat_ltd_sales_vol

sqlda=# SELECT * FROM bat-ltd_sales_vol LIMIT 22;

