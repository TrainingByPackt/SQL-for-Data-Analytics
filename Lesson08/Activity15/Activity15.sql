-- Create the function definition, for a function called avg_sales_window which returns a numeric value and takes a DATE value to specify the date in the form YYYY-mm-dd

sqlda=# CREATE FUNCTION avg_sales_window(from_date DATE, to_date DATE) RETURNS numeric AS $sales_avg$

-- Declare the return variable as a numeric data type and begin the function

sqlda$# DECLARE sales_avg numeric;
sqlda$# BEGIN 

-- Select the average sales amount into the return variable where the sales transaction date is greater than the specified date

sqlda$# SELECT AVG(sales_amount) FROM sales INTO sales_avg WHERE sales_transaction_date > from_date AND sales_transaction_date < to_date;

-- Return the function variable, end the function and specify the language

sqlda$# RETURN sales_avg;
sqlda$# END; $channel_avg$
sqlda-# LANGUAGE PLPGSQL;

-- Use the function to determine the average sales value since 2013-04-12

sqlda=# SELECT avg_sales_since('2013-04-12', '2014-04-12');
