-- Calculate the customer count by the state with at least 1000 customers using the HAVING clause

SELECT state, COUNT(*)
FROM customers
GROUP BY state
HAVING COUNT(*)>=1,000
ORDER BY state
