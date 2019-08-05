-- Calculate the lowest, highest, average and standard deviation price using aggregate functions MIN, MAX, AVG, and STDDEV respectively from the products table and use GROUP BY to check the price of all the different product types

SELECT product_type, MIN(base_msrp), MAX(base_msrp), AVG(base_msrp), STDDEV(base_msrp)
FROM products
GROUP BY 1
ORDER BY 1;
