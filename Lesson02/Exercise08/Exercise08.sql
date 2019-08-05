-- Update the price of Model Chi in products table

UPDATE products
SET base_msrp = base_msrp*1.10
WHERE model='Model Chi'
and year=2019;

-- Select query to check whether the updated price of Model Chi in 2019

SELECT * 
FROM products
WHERE model='Model Chi'
AND year=2019;
