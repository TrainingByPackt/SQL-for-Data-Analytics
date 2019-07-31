-- Create the table with New York City customers

CREATE TABLE customers_nyc AS (
SELECT * FROM 
customers
where city='New York City'
and state='NY');

-- Delete users with postal code 10014

DELETE FROM customers_nyc WHERE postal_code='10014';

-- Add the new column event

ALTER TABLE customers_nyc ADD COLUMN event text;

-- Update customers_nyc table and set the event to 'thank-you party'

UPDATE customers_nyc
SET event = 'thank-you party';

-- Delete the customer_nyc table 

DROP TABLE customers_nyc;