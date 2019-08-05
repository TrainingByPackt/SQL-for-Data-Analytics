-- Calculate the number of unit sales the company has done by using COUNT function

SELECT COUNT(*)
FROM sales;

-- Determine the total sales amount in dollars for each state, we can use the SUM aggregate function here

SELECT c.state, SUM(sales_amount) as total_sales_amount
FROM sales s
INNER JOIN customers c ON c.customer_id=s.customer_id
GROUP BY 1
ORDER BY 1

-- Determine the top 5 dealerships in terms of most units sold, using GROUP BY clause and set LIMIT as 5

SELECT s.dealership_id, COUNT(*)
FROM sales s
WHERE channel='dealership'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Calculate the average sales amount for each channel as seen on the sales table and look at it each by sales channel and product id, and then both of them together. This can be done using GROUPING SETS

SELECT s.channel, s.product_id, AVG(sales_amount) as avg_sales_amount
FROM sales s
GROUP BY 
GROUPING SETS(
(s.channel), (s.product_id),
(s.channel, s.product_id)
)
ORDER BY 1, 2
