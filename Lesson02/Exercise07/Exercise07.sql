-- Create the countries table

CREATE TABLE countries (
key INT PRIMARY KEY,
name text UNIQUE,
founding_year INT,
capital text
);
