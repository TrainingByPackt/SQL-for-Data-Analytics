


# Exercise
9.1: Preliminary Data Collection Using SQL Techniques

*/


-- Active: 1742829589420@@127.0.0.1@54321@sqlda
1. Load the `sqlda` database from the accompanying source code located [here]
(
https:
//github.com/TrainingByPackt/SQL-for-Data-Analytics/tree/master/Datasets).
*/
*/


-- Load the sqlda database
-- Command depends on your database setup
*/


2. List the model, `base_msrp`
(
MSRP:
manufacturer's suggested retail price) and `production_start_date` fields within the product table for product types matching `scooter`.
*/

-- Active: 1738444549781@@127.0.0.1@54321@sqlda
SELECT model, base_msrp, production_start_date
FROM products
WHERE product_type = 'scooter';


3. Extract the model name and product IDs for the scooters available within the database. We will need this information to reconcile the product information with the available sales information.
*/

-- Active: 1738444549781@@127.0.0.1@54321@sqlda@public
SELECT model, product_id INTO product_names
FROM products
WHERE product_type = 'scooter';
SELECT * FROM product_names;


## Exercise 9.2: Extracting the Sales Information
*/



#### 1. Use an inner join on the `product_id` columns of both the `product_names` table and the `sales` table. From the result of the inner join, select the `model`, `customer_id`, `sales_transaction_date`, `sales_amount`, `channel`, and `dealership_id`, and store the values in a separate table called `product_sales`.
*/

SELECT
    model,
    customer_id,
    sales_transaction_date,
    sales_amount,
    channel,
    dealership_id INTO product_sales
FROM sales
    INNER JOIN product_names ON sales.product_id = product_names.product_id;


2. View all rows of the `product_sales` table.
*/

SELECT * FROM product_sales;


3. Select all the information from the `product_sales` table that is available for the Bat Scooter and order the sales information by `sales_transaction_date` in ascending order. By selecting the data in this way, we can look at the first few days of the sales records in detail.
*/

SELECT * FROM product_sales
WHERE model = 'Bat'
ORDER BY sales_transaction_date;


4. Count the number of records available by the following query.
*/

-- Determine the last sale date for the Bat Scooter by selecting the maximum (using the MAX function) for sales_transaction_date
SELECT MAX(sales_transaction_date) FROM products_sales WHERE model='Bat';
