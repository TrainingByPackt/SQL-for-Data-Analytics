-- Use inner join to join the customer table to the sales table. Use inner join to join the product table to the sales table. Use left join to join dealership table to the sales table. Now, return all columns of the customers table and the product table. Then, return the dealership_id from the sales table, but fill in the dealership_id in sales with -1 if it is NULL

SELECT 
c.*,
p.*,
COALESCE(s.dealership_id, -1),
CASE WHEN p.base_msrp - s.sales_amount >500 THEN 1 ELSE 0 END AS high_savings 
FROM sales s
INNER JOIN customers c ON c.customer_id=s.customer_id
INNER JOIN products p ON p.product_id=s.product_id
LEFT JOIN dealerships d ON s.dealership_id = d.dealership_id;
