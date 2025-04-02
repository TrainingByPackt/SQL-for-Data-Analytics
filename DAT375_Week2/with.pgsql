WITH d as (
SELECT * FROM dealerships
    WHERE dealerships.state = 'CA'
    )
SELECT *
FROM salespeople
INNER JOIN d ON d.dealership_id = salespeople.dealership_id
ORDER BY 1;


SELECT SUM(base_msrp)::FLOAT/COUNT(*) AS avg_base_msrp FROM products;