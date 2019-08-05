-- Copy the customers table from your sqlda database to a local file in a CSV format

CREATE TEMP VIEW top_cities AS (
    SELECT city,
           count(1) AS number_of_customers
    FROM customers
    WHERE city IS NOT NULL
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
);
\copy top_cities TO 'top_cities.csv' WITH CSV HEADER DELIMITER ','
DROP VIEW top_cities;
