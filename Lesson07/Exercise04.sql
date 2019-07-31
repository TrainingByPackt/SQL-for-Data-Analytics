-- Check what data do we have in customer_survey

SELECT * FROM customer_survey limit 5;

-- Array transformation

SELECT UNNEST(STRING_TO_ARRAY(feedback, ' ')) AS word, rating FROM customer_survey limit 10;

-- Standardize the text using the ts_lexize function and using the English stemmer 'english_stem'. We will then remove characters that are not letters in our original text using REGEXP_REPLACE 

SELECT 
    (TS_LEXIZE('english_stem',
               UNNEST(STRING_TO_ARRAY(
                   REGEXP_REPLACE(feedback, '[^a-zA-Z]+', ' ', 'g'),
                   ' ')
               )))[1] AS token,
    rating
FROM customer_survey 
LIMIT 10;

-- Average rating associated with each token using a GROUP BY clause

SELECT
    (TS_LEXIZE('english_stem',
               UNNEST(STRING_TO_ARRAY(
                   REGEXP_REPLACE(feedback, '[^a-zA-Z]+', ' ', 'g'),
                   ' ')
               )))[1] AS token,
    AVG(rating) AS avg_rating
FROM customer_survey 
GROUP BY 1
HAVING COUNT(1) >= 3
ORDER BY 2
;

-- Verify the assumptions by filtering survey responses that contain these tokens using an ILIKE expression

SELECT * FROM customer_survey WHERE feedback ILIKE '%pop%';

