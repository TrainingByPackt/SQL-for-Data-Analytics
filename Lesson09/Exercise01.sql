-- Load the sqlda database 

$ psql sqlda

-- List the model, base_msrp (MSRP: Manufacturer Suggested Retail Price) and production_start_date fields within the product table for product types matching scooter

sqlda=# SELECT model, base_msrp, production_start_date FROM products WHERE product_type='scooter';

-- Extract the model name and product Ids for the scooters available within the database

sqlda=# SELECT model, product_id FROM products WHERE product_type='scooter';

-- Insert the results of this query into a new table called product_names

sqlda=# SELECT model, product_id INTO product_names FROM products WHERE product_type='scooter';
