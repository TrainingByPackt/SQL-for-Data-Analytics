-- Connect to the sqlda database

$ psql sqlda

-- Create a function called max_sale that does not take any input arguments but returns a numeric value called big_sale

sqlda=# CREATE FUNCTION max_sale() RETURNS integer AS $big_sale$

-- Declare the variable big_sale and begin the function

sqlda$# DECLARE big_sale numeric;
sqlda$# BEGIN 

-- Insert the maximum sale amount into the big_sale variable

sqlda$# SELECT MAX(sales_amount) INTO big_sale FROM sales; 

-- Return the value for big_sale.

sqlda$# RETURN big_sale; 

-- Closeout the function with the language specification

sqlda$# END; $big_sale$
sqlda-# LANGUAGE PLPGSQL; 

-- Call the function, a amount of the biggest sale in the database?

sqlda=# SELECT MAX(sales_amount) FROM sales;
