-- Create a query that will produce customer_id and a column called region with states categorized 

SELECT c.customer_id,
CASE WHEN c.state in ('MA', 'NH', 'VT', 'ME', 'CT', 'RI') THEN 'New England'
WHEN c.state in ('GA', 'FL', 'MS', 'AL', 'LA', 'KY', 'VA', 'NC', 'SC', 'TN', 'VI', 'WV', 'AR') THEN 'Southeast'
ELSE 'Other' END as region
FROM customers c
ORDER BY 1
