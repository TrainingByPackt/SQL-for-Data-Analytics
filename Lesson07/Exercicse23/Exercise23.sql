-- Create a table with the longitude and latitude point for every customer

CREATE TEMP TABLE customer_points AS (
    SELECT
        customer_id,
        point(longitude, latitude) AS lng_lat_point
    FROM customers
    WHERE longitude IS NOT NULL
    AND latitude IS NOT NULL
);

-- Create a similar table for every dealership

CREATE TEMP TABLE dealership_points AS (
    SELECT
        dealership_id,
        point(longitude, latitude) AS lng_lat_point
    FROM dealerships
);

-- Cross join these table to calculate the distance from each customer to each dealership (in miles)

CREATE TEMP TABLE customer_dealership_distance AS (
    SELECT
       customer_id,
       dealership_id,
       c.lng_lat_point <@> d.lng_lat_point AS distance 
    FROM customer_points c 
    CROSS JOIN dealership_points d
);

-- Take the closest dealership for each customer using the following query

CREATE TEMP TABLE closest_dealerships AS (
    SELECT DISTINCT ON (customer_id) 
        customer_id,
        dealership_id, 
        distance 
    FROM customer_dealership_distance 
    ORDER BY customer_id, distance
);

-- Calculate the average distance from each customer to their closest dealership

SELECT 
    AVG(distance) AS avg_dist,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY distance) AS median_dist
FROM closest_dealerships;
