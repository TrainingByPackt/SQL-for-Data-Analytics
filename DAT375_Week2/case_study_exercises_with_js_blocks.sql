
-- Exercise 9.1: Preliminary Data Collection Using SQL Techniques
*/


1. Load
the `sqlda`
database:
*/

psql sqlda



2. List the model, `base_msrp`, and `production_start_date` for
scooters:
*/

SELECT model, base_msrp, production_start_date
FROM products
WHERE product_type='scooter';


3. Extract model names and product IDs for
scooters:

SELECT model, product_id
FROM products
WHERE product_type='scooter';


4.
Insert results
into `product_names`:

SELECT model, product_id
INTO product_names
FROM products
WHERE product_type='scooter';


-- Exercise 9.2: Extracting the Sales Information

1. Inner join `product_names` and `sales`
tables:

SELECT model, customer_id, sales_transaction_date, sales_amount, channel, dealership_id
INTO products_sales
FROM sales INNER JOIN product_names ON sales.product_id=product_names.product_id;


2. View first five rows of `products_sales`:

SELECT *
FROM products_sales LIMIT
5;


3.
Select Bat Scooter
sales ordered by
date:

SELECT *
FROM products_sales
WHERE model='Bat'
ORDER BY sales_transaction_date;


4. Count Bat Scooter sales
records:

SELECT COUNT(model)
FROM products_sales
WHERE model='Bat';


5. Determine last sale date for Bat
Scooter:

SELECT MAX(sales_transaction_date)
FROM products_sales
WHERE model='Bat';


-- Activity 9.1: Quantifying the Sales Drop

1. Compute daily cumulative sum of
sales:

SELECT *, sum(count) OVER (ORDER BY sales_transaction_date)
INTO bat_sales_growth
FROM bat_sales_daily;


2. Compute 7-day lag of cumulative
sum:

SELECT *, lag(sum, 7) OVER (ORDER BY sales_transaction_date)
INTO bat_sales_daily_delay
FROM bat_sales_growth;


3. Compute sales growth
percentage:

SELECT *, (sum-lag)/lag AS volume
INTO bat_sales_delay_vol
FROM bat_sales_daily_delay;


-- Exercise 9.3: Launch Timing Analysis

1. Examine scooter launch
dates:

SELECT *
FROM products
WHERE product_type='scooter';


2.
Select Bat Limited
Edition
sales:

SELECT products.model, sales.sales_transaction_date
INTO bat_ltd_sales
FROM sales INNER JOIN products ON sales.product_id=products.product_id
WHERE sales.product_id=8
ORDER BY sales.sales_transaction_date;


-- Activity 9.2: Analyzing the Difference in the Sales Price Hypothesis

1.
Select 2013 Lemon
sales:

SELECT sales_transaction_date
INTO lemon_sales
FROM sales
WHERE product_id=3;


2. Compute cumulative sum and lag for Lemon
sales:

SELECT *, sum(count) OVER (ORDER BY sales_transaction_date)
INTO lemon_sales_sum
FROM lemon_sales_count;
SELECT *, lag(sum, 7) OVER (ORDER BY sales_transaction_date)
INTO lemon_sales_delay
FROM lemon_sales_sum;


-- Exercise 9.4: Analyzing Sales Growth by Email Opening Rate

1. Join email and sales data for Bat
Scooter:

SELECT emails.email_subject, emails.customer_id, emails.opened, emails.sent_date, emails.opened_date, bat_sales.sales_transaction_date
INTO bat_emails
FROM emails INNER JOIN bat_sales ON bat_sales.customer_id=emails.customer_id
ORDER BY bat_sales.sales_transaction_date;


-- Exercise 9.5: Analyzing the Performance of the Email Marketing Campaign

1. Join email and sales data for Lemon
Scooter:

SELECT emails.customer_id, emails.email_subject, emails.opened, emails.sent_date, emails.opened_date, lemon_sales.sales_transaction_date
INTO lemon_emails
FROM emails INNER JOIN lemon_sales ON emails.customer_id=lemon_sales.customer_id;
