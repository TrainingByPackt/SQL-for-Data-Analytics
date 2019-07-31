-- Load the prepared functions into the smalljoins database using the Exercise6_functions.sql file found in the accompanying source code

$ psql smalljoins < Exercise6_functions.sql

-- Connect to the smalljoins database

$ psql smalljoins

-- Check a list of the functions using the \df command after loading the function definitions

smalljoins=# \df

-- First, let's look at the current state of the products and order_info tables

smalljoins=# SELECT * FROM products;

-- To the list of the order information we can write the following query

smalljoins=# SELECT * FROM order_info;

-- Insert a new order using the insert_order function with customer_id 4, product_code MON636 and qty 10

smalljoins=# SELECT insert_order(4, 'MON636', 10);

-- Review the entries for the order_info tables

smalljoins=# SELECT * FROM order_info;

-- Update the products table to account for the newly sold 10 Red Herrings using the update_stock function

smalljoins=# SELECT update_stock();

-- Review the products table and notice the updated stock value for Red Herring

smalljoins=# SELECT * FROM products;

-- Delete (DROP) the previous update_stock function

smalljoins=# DROP FUNCTION update_stock;

-- Create a new update_stock function which returns a trigger

smalljoins=# CREATE FUNCTION update_stock() RETURNS TRIGGER AS $stock_trigger$
smalljoins$# DECLARE stock_qty integer;
smalljoins$# BEGIN
smalljoins$# stock_qty := get_stock(NEW.product_code) – NEW.qty;
smalljoins$# UPDATE products SET stock=stock_qty WHERE product_code=NEW.product_code;
smalljoins$# RETURN NEW;
smalljoins$# END; $stock_trigger$
smalljoins-# LANGUAGE PLPGSQL; 

-- Create the trigger

smalljoins=# CREATE TRIGGER update_trigger
smalljoins-# AFTER INSERT ON order_info
smalljoins-# FOR EACH ROW
smalljoins-# EXECUTE PROCEDURE update_stock();

-- Test the created trigger. Call the insert_order function to insert a new record into the order_info table

smalljoins=# SELECT insert_order(4, 'MON123', 2);

-- Look at the records from the order_info table

smalljoins=# SELECT * FROM order_info;

-- Look at the records for the products table

smalljoins=# SELECT * FROM products;