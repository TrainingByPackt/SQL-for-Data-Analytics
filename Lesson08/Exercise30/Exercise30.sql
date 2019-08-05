-- Connect to the sqlda database

$ psql sqlda

-- Create a function, called fixed_val that does not accept any arguments and returns an integer. This is a multi-line process. Enter the following line first

sqlda=# CREATE FUNCTION fixed_val() RETURNS integer AS $$

-- Enter the keyword BEGIN (notice as we are not returning a variable that the line containing the DECLARE statement has been omitted)

sqlda$# BEGIN

-- Return the value 1 from this function, so enter the statement RETURN 1

sqlda$# RETURN 1;

-- End the function definition

sqlda$# END; $$

-- Finally, add the language statement as shown in the function definition above

sqlda-# LANGUAGE PLPGSQL;

-- Now the function is defined we can use it. Like almost all other SQL statements we have completed to date, we simply use a SELECT command

sqlda=# SELECT * FROM fixed_val();

-- Use the EXPLAIN and ANALYZE in combination with this statement to characterize the performance of the function

sqlda=# EXPLAIN ANALYZE SELECT * FROM fixed_val();

-- Create a function called num_samples that does not take any arguments but returns an integer called total that represents the number of samples in the sales table

sqlda=# CREATE FUNCTION num_samples() RETURNS integer AS $total$

-- Return a variable total and thus we need to declare it. Declare the variable total as an integer

sqlda$# DECLARE total integer;

-- Enter the keyword BEGIN

sqlda$# BEGIN

-- Enter the statement that determines the number of samples in the table and assigns the result to the total variable

sqlda$# SELECT COUNT(*) INTO total FROM sales;

-- Return the value for total

sqlda$# RETURN total;

-- End the function, with the variable name

sqlda$# END; $total$

-- Add the language statement as shown in the function definition above

sqlda-# LANGUAGE PLPGSQL;

-- Use the function to determine how many rows or samples are in the sales table

sqlda=# SELECT num_samples();
