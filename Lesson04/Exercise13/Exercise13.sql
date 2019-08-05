-- Calculate the lowest, highest, average and standard deviation price using aggregate functions MIN, MAX, AVG, and STDDEV respectively from the products table

SELECT MIN(base_msrp), MAX(base_msrp), AVG(base_msrp), STDDEV(base_msrp)
FROM products;