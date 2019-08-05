-- Load the sqlda database

$ psql sqlda

-- Compute the daily cumulative sum of sales using the OVER and ORDER BY statements. Insert the results into a new table called bat_sales_growth

sqlda=# SELECT *, sum(count) OVER (ORDER BY sales_transaction_date) INTO bat_sales_growth FROM bat_sales_daily;

-- Compute a seven-day LAG of the sum column and insert all columns of bat_sales_daily and the new lag column into a new table bat_sales_daily_delay. This lag column indicates what the sales were like one week before the given record.

sqlda=# SELECT *, lag(sum, 7) OVER (ORDER BY sales_transaction_date) INTO bat_sales_daily_delay FROM bat_sales_growth;

-- Inspect the first 15 rows of bat_sales_growth

sqlda=# SELECT * FROM bat_sales_daily_delay LIMIT 15;

-- Compute the sales growth as a percentage comparing the current sales volume to that of one week prior. Insert the resulting table into a new table called bat_sales_delay_vol

sqlda=# SELECT *, (sum-lag)/lag AS volume INTO bat_sales_delay_vol FROM bat_sales_daily_delay ;

-- Compare the first 22 values of the table bat_sales_delay_vol

sqlda=# SELECT * FROM bat_sales_daily_delay_vol LIMIT 22;




