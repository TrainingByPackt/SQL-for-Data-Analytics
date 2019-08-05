-- Load the sqlda database

$ psql sqlda

-- Select the sales_transaction_date column from the 2013 Lemon sales and insert into a table called lemon_sales

sqlda=# SELECT sales_transaction_date INTO lemon_sales FROM sales WHERE product_id=3;

-- Count the sales records available for the 2013 Lemon by running the following query

sqlda=# SELECT count(sales_transaction_date) FROM lemon_sales;

-- Use the max function to check latest sales_transaction_date

sqlda=# SELECT max(sales_transaction_date) FROM lemon_sales;

-- Convert the sales_transaction_date column to a date type using the following query

sqlda=# ALTER TABLE lemon_sales ALTER COLUMN sales_transaction_date TYPE DATE;

-- Count the number of sales per day within the lemon_sales table and insert into a table called lemon_sales_count

sqlda=# SELECT *, COUNT(sales_transaction_date) INTO lemon_sales_count FROM lemon_sales GROUP BY sales_transaction_date,lemon_sales.customer_id ORDER BY sales_transaction_date;

-- Calculate the cumulative sum of sales and insert the corresponding table into a new table labeled lemon_sales_sum

sqlda=# SELECT *, sum(count) OVER (ORDER BY sales_transaction_date) INTO lemon_sales_sum FROM lemon_sales_count;

-- Compute the 7-day lag on the sum column and save the result to lemon_sales_delay

sqlda=# SELECT *, lag(sum, 7) OVER (ORDER BY sales_transaction_date) INTO lemon_sales_delay FROM lemon_sales_sum;

-- Calculate the growth rate using the data from lemon_sales_delay and store the resulting table into lemon_sales_growth. Label the growth rate column as volume

sqlda=# SELECT *, (sum-lag)/lag AS volume INTO lemon_sales_growth FROM lemon_sales_delay;

-- Inspect the first 22 records of the lemon_sales_growth table examining the volume data

sqlda=# SELECT * FROM lemon_sales_growth LIMIT 22;

