-- Use inner join to bring the tables' sales and customers together, which returns data for the following: customer ids, first name, last name, and valid phone number

SELECT c.customer_id,
c.first_name,
c.last_name,
c.phone
FROM sales s
INNER JOIN customers c ON c.customer_id=s.customer_id
INNER JOIN products p ON p.product_id=s.product_id
WHERE p.product_type='automobile'
AND c.phone IS NOT NULL
