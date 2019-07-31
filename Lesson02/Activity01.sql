-- Fetch customers in the state of Florida in alphabetical order

SELECT email
FROM customers
WHERE state='FL'
ORDER BY email

-- Pull all the first names, last names, and email for ZoomZoom customers in the city of New York City, New York

SELECT first_name, last_name, email
FROM customers
WHERE city='New York City'
and state='NY'
ORDER BY last_name, first_name

-- Fetch all customers that have a phone number ordered by the date the customer was added to the database

SELECT *
FROM customers
WHERE phone IS NOT NULL
ORDER BY date_added
