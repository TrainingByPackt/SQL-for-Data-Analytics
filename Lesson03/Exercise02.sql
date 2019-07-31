-- List of ZoomZoom customers and Employee of the company who lives in Los Angeles, CA. The guest list should contain first name, last name, and whether the guest is a customer or an employee
(
SELECT first_name, last_name, 'Customer' as guest_type
FROM customers
WHERE city='Los Angeles'
AND state='CA'
)
UNION
(
SELECT first_name, last_name, 'Employee' as guest_type
FROM salespeople s
INNER JOIN dealerships d ON d.dealership_id=s.dealership_id
WHERE d.city='Los Angeles'
AND d.state='CA'
)
