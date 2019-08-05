-- Calculate total sales amount for all months in the year of 2018, using SUM function

SELECT sales_transaction_date::DATE,
SUM(sales_amount) as total_sales_amount
FROM sales
WHERE sales_transaction_date>='2018-01-01'
AND sales_transaction_date<'2019-01-01'
GROUP BY 1
ORDER BY 1;

-- Now, calculate the rolling 30-day average for allows a daily number of sales deals, using window frame

WITH daily_deals as (
SELECT sales_transaction_date::DATE,
COUNT(*) as total_deals
FROM sales
GROUP BY 1
),

moving_average_calculation_30 AS (
SELECT sales_transaction_date, total_deals,
AVG(total_deals) OVER (ORDER BY sales_transaction_date ROWS BETWEEN 30 PRECEDING and CURRENT ROW) AS deals_moving_average,
ROW_NUMBER() OVER (ORDER BY sales_transaction_date) as row_number
FROM daily_deals
ORDER BY 1)

SELECT sales_transaction_date,
CASE WHEN row_number>=30 THEN deals_moving_average ELSE NULL END
   AS deals_moving_average_30
FROM moving_average_calculation_30
WHERE sales_transaction_date>=‘2018-01-01'
AND sales_transaction_date<‘2019-01-01';

-- Next, calculate what decile each dealership would be in compared to other dealerships based on total sales amount, using window functions

WITH total_dealership_sales AS
(
SELECT dealership_id,
SUM(sales_amount) AS total_sales_amount
FROM sales
WHERE sales_transaction_date>='2018-01-01'
AND sales_transaction_date<'2019-01-01'
AND channel='dealership'
GROUP BY 1
)

SELECT *,
NTILE(10) OVER (ORDER BY total_sales_amount)
FROM total_dealership_sales;
