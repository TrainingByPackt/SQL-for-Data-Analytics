-- Calculate a rank for every salesperson with a rank of 1 going to the first hire, 2 to the second hire, and so on using RANK() function

SELECT *,
RANK() OVER (PARTITION BY dealership_id ORDER BY hire_date)
FROM salespeople
WHERE termination_date IS NULL;
