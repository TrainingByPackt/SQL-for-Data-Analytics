-- Create the materialized view on the customer_sales table

CREATE MATERIALIZED VIEW customer_search AS (
    SELECT 
        customer_json -> 'customer_id' AS customer_id,
        customer_json,
        to_tsvector('english', customer_json) AS search_vector
    FROM customer_sales
);

-- Create the GIN index on the view

CREATE INDEX customer_search_gin_idx ON customer_search USING GIN(search_vector);

-- Solve the request by using our new searchable database

SELECT
    customer_id,
    customer_json
FROM customer_search 
WHERE search_vector @@ plainto_tsquery('english', 'Danny Bat');

-- Unique list of scooters and automobiles (and remove limited editions) using DISTINCT

SELECT DISTINCT 
    p1.model, 
    p2.model
FROM products p1 
LEFT JOIN products p2 ON TRUE 
WHERE p1.product_type = 'scooter' 
AND p2.product_type = 'automobile' 
AND p1.model NOT ILIKE '%Limited Edition%';

-- Transform the output into the query

SELECT DISTINCT 
    plainto_tsquery('english', p1.model) && 
    plainto_tsquery('english', p2.model) 
FROM products p1 
LEFT JOIN products p2 ON TRUE 
WHERE p1.product_type = 'scooter' 
AND p2.product_type = 'automobile' 
AND p1.model NOT ILIKE '%Limited Edition%';

-- Query our database using each of these tsquery objects, and count the occurrences for each object

SELECT 
    sub.query, 
    (
        SELECT COUNT(1) 
        FROM customer_search
        WHERE customer_search.search_vector @@ sub.query)
FROM (
    SELECT DISTINCT 
        plainto_tsquery('english', p1.model) && 
        plainto_tsquery('english', p2.model) AS query
    FROM products p1 
    LEFT JOIN products p2 ON TRUE 
    WHERE p1.product_type = 'scooter' 
    AND p2.product_type = 'automobile' 
    AND p1.model NOT ILIKE '%Limited Edition%'
) sub 
ORDER BY 2 DESC;
