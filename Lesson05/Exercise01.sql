-- Use window functions and write a query that will return customer information, and count the number of people through the date in the row have filled out their street address

SELECT customer_id, street_address, date_added::DATE,
COUNT(CASE WHEN street_address IS NOT NULL THEN customer_id ELSE NULL END)
    OVER (ORDER BY date_added::DATE) as total_customers_filled_street
FROM customers
ORDER BY date_added;

