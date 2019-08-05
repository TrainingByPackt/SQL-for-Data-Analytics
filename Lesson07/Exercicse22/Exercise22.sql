-- Aggregate query, using the DATE_TRUNC method

SELECT 
    DATE_TRUNC('month', sales_transaction_date)
        AS month_date,
    COUNT(1) AS number_of_sales
FROM sales
WHERE EXTRACT(year FROM sales_transaction_date) = 2018
GROUP BY 1
ORDER BY 1;

-- compares with the number of new customers joining each month

SELECT 
    DATE_TRUNC('month', date_added)
        AS month_date,
    COUNT(1) AS number_of_new_customers
FROM customers
WHERE EXTRACT(year FROM date_added) = 2018
GROUP BY 1
ORDER BY 1;
