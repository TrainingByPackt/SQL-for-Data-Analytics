-- Connect to the sqlda database

$ psql sqlda

-- Create a function avg_sales that takes a text argument input channel_type and returns a numeric output

sqlda=# CREATE FUNCTION avg_sales(channel_type TEXT) RETURNS numeric AS $channel_avg$

-- Declare the numeric channel_avg variable and begin the function

sqlda$# DECLARE channel_avg numeric;
sqlda$# BEGIN 

-- Determine the average sales_amount only when the channel value is equal to channel_type

sqlda$# SELECT AVG(sales_amount) INTO channel_avg FROM sales WHERE channel=channel_type; 

-- Return channel_avg

sqlda$# RETURN channel_avg; 

-- End the function and specify the language

sqlda$# END; $channel_avg$
sqlda-# LANGUAGE PLPGSQL;
 
-- Determine the average sale amount for both the internet and dealership channels

sqlda=# SELECT avg_sales('internet');

-- Average sales for dealership

sqlda=# SELECT avg_sales('dealership');
