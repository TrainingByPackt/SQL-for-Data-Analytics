-- Connect to the smalljoins database

$ psql smalljoins

-- Create a new table called avg_qty_log that is composed of an order_id integer field and an avg_qty numeric field

smalljoins=# CREATE TABLE avg_qty_log (order_id integer, avg_qty numeric);

-- Create a function called avg_qty that does not take any arguments but returns a trigger. The function computes the average value for all order quantities (order_info.qty) and inserts the average value along with the most recent order_id into avg_qty.

smalljoins=# CREATE FUNCTION avg_qty() RETURNS TRIGGER AS $_avg$
smalljoins$# DECLARE _avg numeric;
smalljoins$# BEGIN
smalljoins$# SELECT AVG(qty) INTO _avg FROM order_info;
smalljoins$# INSERT INTO avg_qty_log (order_id, avg_qty) VALUES (NEW.order_id, _avg);
smalljoins$# RETURN NEW;
smalljoins$# END; $_avg$
smalljoins-# LANGUAGE PLPGSQL; 

-- Create a trigger called avg_trigger that calls the avg_qty function AFTER each row is inserted into the order_info table

smalljoins=# CREATE TRIGGER avg_trigger
smalljoins-# AFTER INSERT ON order_info
smalljoins-# FOR EACH ROW
smalljoins-# EXECUTE PROCEDURE avg_qty();

-- Insert some new rows into the order_info table with quantities of 6, 7 and 8

smalljoins=# SELECT insert_order(3, 'GROG1', 6);
smalljoins=# SELECT insert_order(4, 'GROG1', 7);
smalljoins=# SELECT insert_order(1, 'GROG1', 8);

-- Look at the entries in avg_qty_log is the average quantity of each order increasing?

smalljoins=# SELECT * FROM avg_qty_log;
