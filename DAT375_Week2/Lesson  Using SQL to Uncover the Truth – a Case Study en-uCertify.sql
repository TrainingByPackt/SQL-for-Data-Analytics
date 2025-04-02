
# Lesson : Using SQL to Uncover the Truth – a Case Study en-uCertify

> ## Excerpt
>
> uCertify offers online computer courses and hands-on labs on project management, data analytics, cybersecurity, and more to advance your IT career. en

---
In this case study, we will be following the scientific method to help solve our problem, which, at its heart, is about testing guesses (or hypotheses) using objectively collected data. We can decompose the scientific method into the following key steps:

1. Define the question to answer what caused the drop-in sales of the Bat Scooter after approximately 2 weeks.
2. Complete background research to gather sufficient information to propose an initial hypothesis for the event or phenomenon.
3. Construct a hypothesis to explain the event or answer the question.
4. Define and execute an objective experiment to test the hypothesis. In an ideal scenario, all aspects of the experiment should be controlled and fixed, except for the phenomenon that is being tested under the hypothesis.
5. Analyze the data collected during the experiment.
6. Report the result of the analysis, which will hopefully explain why there was a drop in the sale of Bat Scooters.

It is to be noted that in this lesson, we are completing a post-hoc analysis of the data, that is, the event has happened, and all available data has been collected. Post-hoc data analysis is particularly useful when events have been recorded that cannot be repeated or when certain external factors cannot be controlled. It is with this data that we are able to perform our analysis, and, as such, we will extract information to support or refute our hypothesis. We will, however, be unable to definitively confirm or reject the hypothesis without practical experimentation. The question that will be the subject of this lesson and that we need to answer is this: why did the sales of the ZoomZoom Bat Scooter drop by approximately 20% after about 2 weeks?

So, let's start with the absolute basics.

Exercise 9.1: Preliminary Data Collection Using SQL Techniques

In this exercise, we will collect preliminary data using SQL techniques. We have been told that the pre-orders for the ZoomZoom Bat Scooter were good, but the orders suddenly dropped by 20%. So, when was production started on the scooter, and how much was it selling for? How does the Bat Scooter compare with other types of scooters in terms of price? The goal of this exercise is to answer these questions:

1. Load the `sqlda` database from the accompanying source code is located [here](https://github.com/TrainingByPackt/SQL-for-Data-Analytics/tree/master/Datasets):

    ```javascript
    psql sqlda
    ```

2. List the model, `base_msrp` (MSRP: manufacturer's suggested retail price) and `production_start_date` fields within the product table for product types matching `scooter`:

    ```javascript
    SELECT model, base_msrp, production_start_date FROM products WHERE product_type='scooter';
    ```

    The following table shows the details of all the products for the `scooter` product type:

    | model | base\_msrp | production\_start\_date |
    | --- | --- | --- |
    | Lemon | 399.99 | 2010-03-03 00:00:00 |
    | Lemon Limited Edition | 799.99 | 2011-01-03 00:00:00 |
    | Lemon | 499.99 | 2013-05-01 00:00:00 |
    | Blade | 699.99 | 2014-06-23 00:00:00 |
    | Bat | 599.99 | 2016-10-10 00:00:00 |
    | Bat Limited Edition | 699.99 | 2017-02-15 00:00:00 |
    | Lemon Zester (7 rows) | 349.99 | 2019-02-04 00:00:00 |

    Figure 9.1: Basic list of scooters with a base manufacturer suggesting a retail price and production date

    Looking at the results from the search, we can see that we have two scooter products with **Bat** in the name; **Bat** and **Bat Limited Edition**. The **Bat** Scooter, which started production on October 10, 2016, with a suggested retail price of $599.99; and the **Bat Limited Edition** Scooter, which started production approximately 4 months later, on February 15, 2017, at a price of $699.99.

    Looking at the product information supplied, we can see that the Bat Scooter is somewhat unique from a price perspective, being the only scooter with a suggested retail price of $599.99. There are two others at $699.99 and one at $499.99.

    Similarly, if we consider the production start date in isolation, the original Bat Scooter is again unique in that it is the only scooter starting production in the last quarter or even half of the year (date format: _YYYY-MM-DD_). All other scooters start production in the first half of the year, with only the Blade scooter starting production in June.

    In order to use the sales information in conjunction with the product information available, we also need to get the product ID for each of the scooters.

3. Extract the model name and product IDs for the scooters available within the database. We will need this information to reconcile the product information with the available sales information:

    ```javascript
    SELECT model, product_id FROM products WHERE product_type='scooter';
    ```

    The query yields the product IDs shown in the following table:

    | model | product\_id |
    | --- | --- |
    | Lemon | 1 |
    | Lemon Limited Edition | 2 |
    | Lemon | 3 |
    | Blade | 5 |
    | Bat | 7 |
    | Bat Limited Edition | 8 |
    | Lemon Zester (7 rows) | 12 |

    Figure 9.2: Scooter product ID codes

4. Insert the results of this query into a new table called `product_names`:

    ```javascript
    SELECT model, product_id INTO product_names FROM products WHERE product_type='scooter';
    ```

    Inspect the contents of the `product_names` table shown in the following figure:

    | model | product\_id |
    | --- | --- |
    | Lemon | 1 |
    | Lemon Limited Edition | 2 |
    | Lemon | 3 |
    | Blade | 5 |
    | Bat | 7 |
    | Bat Limited Edition | 8 |
    | Lemon Zester (7 rows) | 12 |

    Figure 9.3: Contents of the new product\_names table

As described in the output, we can see that the Bat Scooter lies between the price points of some of the other scooters and that it was also manufactured a lot later in the year compared to the others.

By completing this very preliminary data collection step, we have the information required to collect sales data on the Bat Scooter as well as other scooter products for comparison. While this exercise involved using the simplest SQL commands, it has already yielded some useful information.

This exercise has also demonstrated that even the simplest SQL commands can reveal useful information and that they should not be underestimated. In the next exercise, we will try to extract the sales information related to the reduction in sales of the Bat Scooter.

Exercise 9.2: Extracting the Sales Information

In this exercise, we will use a combination of simple `SELECT` statements, as well as aggregate and window functions, to examine the sales data. With the preliminary information at hand, we can use it to extract the Bat Scooter sales records and discover what is actually going on. We have a table, `product_names`, that contains both the model names and product IDs. We will need to combine this information with the sales records and extract only those for the Bat Scooter:

1. Load the `sqlda` database:

    ```javascript
    psql sqlda
    ```

2. List the available fields in the `sqlda` database:

    ```javascript
    \d
    ```

    The preceding query yields the following fields present in the database:

    | Column | Table "public.sales" Type | Collation | Nullable | Default |
    | --- | --- | --- | --- | --- |
    | customer\_id | bigint |  |  |  |
    | product\_id | bigint |  |  |  |
    | sales\_transaction\_date | timestamp without time zone |  |  |  |
    | sales\_amount | double precision |  |  |  |
    | channel | text |  |  |  |
    | dealership\_id | double precision |  |  |  |

    Figure 9.4: Structure of the sales table

    We can see that we have references to customer and product IDs, as well as the transaction date, sales information, the sales channel, and the dealership ID.
3. Use an inner join on the `product_id` columns of both the `product_names` table and the sales table. From the result of the inner join, select the model, `customer_id`, `sales_transaction_date`, `sales_amount`, channel, and `dealership_id`, and store the values in a separate table called `product_sales`:

    ```javascript
    SELECT model, customer_id, sales_transaction_date, sales_amount, channel, dealership_id INTO products_sales FROM sales INNER JOIN product_names ON sales.product_id=product_names.product_id;
    ```

    The output of the preceding code can be seen in the next step.  

    Note

    Throughout this lesson, we will be storing the results of queries and calculations in separate tables as this will allow you to look at the results of the individual steps in the analysis at any time. In a commercial/production setting, we would typically only store the end result in a separate table, depending upon the context of the problem being solved.

4. Look at the first five rows of this new table by using the following query:

    ```javascript
    SELECT * FROM products_sales LIMIT 5;
    ```

    The following table lists the top five customers who made a purchase. It shows the sale amount and the transaction details, such as the date and time:

    | model | customer\_id | sales\_transaction\_date | sales\_amount | channel | dealership\_id |
    | --- | --- | --- | --- | --- | --- |
    | Lemon | 41604 | 2012-03-30 22:45:29 | 399.99 | internet |  |
    | Lemon | 41531 | 2010-09-07 22:53:16 | 399.99 | internet |  |
    | Lemon | 41443 | 2011-05-24 02:19:11 | 399.99 | internet |  |
    | Lemon | 41291 | 2010-08-08 14:12:52 | 319.992 | internet |  |
    | Lemon | 41084 | 2012-01-09 03:34:52 | 319.992 | internet |  |
    | (5 rows) |

    Figure 9.5: The combined product sales table

5. Select all the information from the `product_sales` table that is available for the Bat Scooter and order the sales information by `sales_transaction_date` in ascending order. By selecting the data in this way, we can look at the first few days of the sales records in detail:

    ```javascript
    SELECT * FROM products_sales WHERE model='Bat' ORDER BY sales_transaction_date;
    ```

    The preceding query generates the following output:

    | model | customer\_id | sales\_transaction\_date | sales\_amount | channel | dealership\_id |
    | --- | --- | --- | --- | --- | --- |
    | Bat | 4319 | 2016-10-10 00:41:57 | 599.99 | Internet |  |
    | Bat | 40250 | 2016-10-10 02:47:28 | 599.99 | dealership | 4 |
    | Bat | 35497 | 2016-10-10 04:21:08 | 599.99 | dealership | 2 |
    | Bat | 4553 | 2016-10-10 07:42:59 | 599.99 | dealership | 11 |
    | Bat | 11678 | 2016-10-10 09:21:08 | 599.99 | internet |  |
    | Bat | 45868 | 2016-10-10 10:29:29 | 599.99 | internet |
    | Bat | 24125 | 2016-10-10 18:57:25 | 599.99 | dealership | 1 |
    | Bat | 31307 | 2016-10-10 21:22:38 | 599.99 | internet |  |
    | Bat | 42213 | 2016-10-10 21:27:36 | 599.99 | internet |  |
    | Bat | 47790 | 2016-10-11 01:28:58 | 599.99 | dealership | 20 |
    | Bat | 6342 | 2016-10-11 03:04:57 | 599.99 | internet |  |
    | Bat | 45880 | 2016-10-11 04:09:19 | 599.99 | dealership | 7 |
    | Bat | 43477 | 2016-10-11 05:24:50 | 599.99 | internet |  |
    | Bat | 6322 | 2016-10-11 08:48:07 | 599.99 | internet |
    | Bat | 46653 | 2016-10-11 15:47:01 | 599.99 | dealership | 6 |
    | Bat | 9045 | 2016-10-12 00:15:20 | 599.99 | dealership | 19 |
    | Bat | 23679 | 2016-10-12 00:17:53 | 539.991 | internet |  |
    | Bat | 49856 | 2016-10-12 00:26:15 | 599.99 | dealership | 10 |
    | Bat | 45256 | 2016-10-12 02:08:01 | 539.991 | dealership | 7 |
    | Bat | 48809 | 2016-10-12 05:08:43 | 599.99 | internet |  |
    | Bat | 42625 | 2016-10-12 06:17:55 | 599.99 | internet |  |
    | Bat | 39653 | 2016-10-12 06:28:25 | 599.99 | dealership | 7 |
    | Bat | 49226 | 2016-10-12 10:26:13 | 539.991 | internet |  |
    | Bat | 18602 | 2016-10-12 15:09:53 | 599.99 | internet |  |

    Figure 9.6: Ordered sales records

6. Count the number of records available by using the following query:

    ```javascript
    SELECT COUNT(model) FROM products_sales WHERE model='Bat';
    ```

    The model count for the `'Bat'` model is as shown here:

    ```javascript
    count --------- 7328 (1 row)
    ```

    **Figure 9.7: Count of the number of sales records**

    So, we have **7328** sales, beginning October 10, 2016. Check the date of the final sales record by performing the next step.
7. Determine the last sale date for the Bat Scooter by selecting the maximum (using the `MAX` function) for `sales_transaction_date`:

    ```javascript
    SELECT MAX(sales_transaction_date) FROM products_sales WHERE model='Bat';
    ```

    The last sale date is shown here:

    ```javascript
    Max ------------------ 2019-05-31 22:15:30 (1 row)
    ```

    Figure 9.8: Last sale date

    The last sale in the database occurred on May 31, 2019.
8. Collect the daily sales volume for the Bat Scooter and place it in a new table called `bat_sales` to confirm the information provided by the sales team stating that sales dropped by 20% after the first 2 weeks:

    ```javascript
    SELECT * INTO bat_sales FROM products_sales WHERE model='Bat' ORDER BY sales_transaction_date;
    ```

9. Remove the time information to allow tracking of sales by date, since, at this stage, we are not interested in the time at which each sale occurred. To do so, run the following query:

    ```javascript
    UPDATE bat_sales SET sales_transaction_date=DATE(sales_transaction_date);
    ```

10. Display the first five records of `bat_sales` ordered by `sales_transaction_date`:

    ```javascript
    SELECT * FROM bat_sales ORDER BY sales_transaction_date LIMIT 5;
    ```

    The following is the output of the preceding code:

    | model | customer\_id | sales\_transaction\_date | sales\_amount | channel | dealership\_id |
    | --- | --- | --- | --- | --- | --- |
    | Bat | 4553 | 2016-10-10 00:00:00 | 599.99 | dealership | 11 |
    | Bat | 35497 | 2016-10-10 00:00:00 | 599.99 | dealership | 2 |
    | Bat | 40250 | 2016-10-10 00:00:00 | 599.99 | dealership | 4 |
    | Bat | 4319 | 2016-10-10 00:00:00 | 599.99 | internet |  |
    | Bat | 11678 | 2016-10-10 00:00:00 | 599.99 | internet |  |
    | (5 rows) |

    Figure 9.9: First five records of Bat Scooter sales

    Create a new table (`bat_sales_daily`) containing the sales transaction dates and a daily count of total sales:

    ```javascript
    SELECT sales_transaction_date, COUNT(sales_transaction_date) INTO bat_sales_daily FROM bat_sales GROUP BY sales_transaction_date ORDER BY sales_transaction_date;
    ```

11. Examine the first `22` records (a little over 3 weeks), as sales were reported to have dropped after approximately the first 2 weeks:

    ```javascript
    SELECT * FROM bat_sales_daily LIMIT 22;
    ```

    This will display the following output:

    | sales\_transaction\_date | count |
    | --- | --- |
    | 2016-10-10 00:00:00 | 9 |
    | 2016-10-11 00:00:00 | 6 |
    | 2016-10-12 00:00:00 | 10 |
    | 2016-10-13 00:00:00 | 10 |
    | 2016-10-14 00:00:00 | 5 |
    | 2016-10-15 00:00:00 | 10 |
    | 2016-10-16 00:00:00 | 14 |
    | 2016-10-17 00:00:00 | 9 |
    | 2016-10-18 00:00:00 | 11 |
    | 2016-10-19 00:00:00 | 12 |
    | 2016-10-20 00:00:00 | 10 |
    | 2016-10-21 00:00:00 | 6 |
    | 2016-10-22 00:00:00 | 2 |
    | 2016-10-23 00:00:00 | 5 |
    | 2016-10-24 00:00:00 | 6 |
    | 2016-10-25 00:00:00 | 9 |
    | 2016-10-26 00:00:00 | 2 |
    | 2016-10-27 00:00:00 | 4 |
    | 2016-10-28 00:00:00 | 7 |
    | 2016-10-29 00:00:00 | 5 |
    | 2016-10-30 00:00:00 | 5 |
    | 2016-10-31 00:00:00 | 3 |
    | (22 rows) |

    Figure 9.10: First 3 weeks of sales

We can see a drop-in sales after October 20, as there are 7 days in the first 11 rows that record double-digit sales, and none over the next 11 days.

At this stage, we can confirm that there has been a drop off in sales, although we are yet to quantify precisely the extent of the reduction or the reason for the drop off in sales.

Activity 9.1: Quantifying the Sales Drop

In this activity, we will use our knowledge of the windowing methods that we learned in _Lesson 5_, _Window Functions for Data Analysis_. In the previous exercise, we identified the occurrence of the sales drop as being approximately 10 days after launch. Here, we will try to quantify the drop off in sales for the Bat Scooter.

Perform the following steps to complete the activity:

1. Load the `sqlda` database from the accompanying source code located at this [link](https://github.com/TrainingByPackt/SQL-for-Data-Analytics/tree/master/Datasets).
2. Using the `OVER` and `ORDER BY` statements, compute the daily cumulative sum of sales. This provides us with a discrete count of sales over time on a daily basis. Insert the results into a new table called `bat_sales_growth`.
3. Compute a 7-day `lag` of the `sum` column, and then insert all the columns of `bat_sales_daily` and the new `lag` column into a new table, `bat_sales_daily_delay`. This `lag` column indicates what sales were like 1 week prior to the given record, allowing us to compare sales with the previous week.
4. Inspect the first 15 rows of `bat_sales_growth`.
5. Compute the sales growth as a percentage, comparing the current sales volume to that of 1 week prior. Insert the resulting table into a new table called `bat_sales_delay_vol`.
6. Compare the first 22 values of the `bat_sales_delay_vol` table to ascertain a sales drop.

**Solution**

1. Load the sqlda database:

    ```javascript
    psql sqlda
    ```

2. Compute the daily cumulative sum of sales using the OVER and ORDER BY statements. Insert the results into a new table called bat\_sales\_growth:

    ```javascript
    SELECT *, sum(count) OVER (ORDER BY sales_transaction_date) INTO bat_sales_growth FROM bat_sales_daily;
    ```

    The following table shows the daily cumulative sum of sales:

    | sales\_transaction\_date | count | sum |
    | --- | --- | --- |
    | 2016-10-10 00:00:00 | 9 | 9 |
    | 2016-10-11 00:00:00 | 6 | 15 |
    | 2016-10-12 00:00:00 | 10 | 25 |
    | 2016-10-13 00:00:00 | 10 | 35 |
    | 2016-10-14 00:00:00 | 5 | 40 |
    | 2016-10-15 00:00:00 | 10 | 50 |
    | 2016-10-16 00:00:00 | 14 | 64 |
    | 2016-10-17 00:00:00 | 9 | 73 |
    | 2016-10-18 00:00:00 | 11 | 84 |
    | 2016-10-19 00:00:00 | 12 | 96 |
    | 2016-10-20 00:00:00 | 10 | 106 |
    | 2016-10-21 00:00:00 | 6 | 112 |
    | 2016-10-22 00:00:00 | 2 | 114 |
    | 2016-10-23 00:00:00 | 5 | 119 |
    | 2016-10-24 00:00:00 | 6 | 125 |
    | 2016-10-25 00:00:00 | 9 | 134 |
    | 2016-10-26 00:00:00 | 2 | 136 |
    | 2016-10-27 00:00:00 | 4 | 140 |
    | 2016-10-28 00:00:00 | 7 | 147 |
    | 2016-10-29 00:00:00 | 5 | 152 |
    | 2016-10-30 00:00:00 | 5 | 157 |
    | 2016-10-31 00:00:00 | 3 | 160 |

    Figure A: Daily sales count

3. Compute a 7-day lag function of the sum column and insert all the columns of bat\_sales\_daily and the new lag column into a new table, bat\_sales\_daily\_delay. This lag column indicates what the sales were like 1 week before the given record:

    ```javascript
    SELECT *, lag(sum, 7) OVER (ORDER BY sales_transaction_date) INTO bat_sales_daily_delay FROM bat_sales_growth;
    ```

4. Inspect the first 15 rows of bat\_sales\_growth:

    ```javascript
    SELECT * FROM bat_sales_daily_delay LIMIT 15;
    ```

    The following is the output of the preceding code:

    | sales\_transaction\_date | count | sum | lag |
    | --- | --- | --- | --- |
    | 2016-10-10 00:00:00 | 9 | 9 |  |
    | 2016-10-11 00:00:00 | 6 | 15 |  |
    | 2016-10-12 00:00:00 | 10 | 25 |  |
    | 2016-10-13 00:00:00 | 10 | 35 |  |
    | 2016-10-14 00:00:00 | 5 | 40 |  |
    | 2016-10-15 00:00:00 | 10 | 50 |  |
    | 2016-10-16 00:00:00 | 14 | 64 |  |
    | 2016-10-17 00:00:00 | 9 | 73 | 9 |
    | 2016-10-18 00:00:00 | 11 | 84 | 15 |
    | 2016-10-19 00:00:00 | 12 | 96 | 25 |
    | 2016-10-20 00:00:00 | 10 | 106 | 35 |
    | 2016-10-21 00:00:00 | 6 | 112 | 40 |
    | 2016-10-22 00:00:00 | 2 | 114 | 50 |
    | 2016-10-23 00:00:00 | 5 | 119 | 64 |
    | 2016-10-24 00:00:00 | 6 | 125 | 73 |
    | (15 rows) |

    Figure B: Daily sales delay with lag

5. Compute the sales growth as a percentage, comparing the current sales volume to that of 1 week prior. Insert the resulting table into a new table called bat\_sales\_delay\_vol:

    ```javascript
    SELECT *, (sum-lag)/lag AS volume INTO bat_sales_delay_vol FROM bat_sales_daily_delay ;
    ```

    Note

    The percentage sales volume can be calculated via the following equation:

    ```javascript
    (new_volume – old_volume) / old_volume
    ```

6. Compare the first 22 values of the bat\_sales\_delay\_vol table:

    ```javascript
    SELECT * FROM bat_sales_daily_delay_vol LIMIT 22;
    ```

    The delay volume for the first 22 entries can be seen in the following:

    | sales\_transaction\_date | count | sum | lag | volume |
    | --- | --- | --- | --- | --- |
    | 2016-10-10 00:00:00 | 9 | 9 |  |  |
    | 2016-10-11 00:00:00 | 6 | 15 |  |  |
    | 2016-10-12 00:00:00 | 10 | 25 |  |  |
    | 2016-10-13 00:00:00 | 10 | 35 |  |  |
    | 2016-10-14 00:00:00 | 5 | 40 |  |  |
    | 2016-10-15 00:00:00 | 10 | 50 |  |  |
    | 2016-10-16 00:00:00 | 14 | 64 |  |  |
    | 2016-10-17 00:00:00 | 9 | 73 | 9 | 7.1111111111111111 |
    | 2016-10-18 00:00:00 | 11 | 84 | 15 | 4.6000000000000000 |
    | 2016-10-19 00:00:00 | 12 | 96 | 25 | 2.8400000000000000 |
    | 2016-10-20 00:00:00 | 10 | 106 | 35 | 2.0285714285714286 |
    | 2016-10-21 00:00:00 | 6 | 112 | 40 | 1.8000000000000000 |
    | 2016-10-22 00:00:00 | 2 | 114 | 50 | 1.2800000000000000 |
    | 2016-10-23 00:00:00 | 5 | 119 | 64 | 0.85937500000000000000 |
    | 2016-10-24 00:00:00 | 6 | 125 | 73 | 0.71232876712328767123 |
    | 2016-10-25 00:00:00 | 9 | 134 | 84 | 0.59523809523809523810 |
    | 2016-10-26 00:00:00 | 2 | 136 | 96 | 0.41666666666666666667 |
    | 2016-10-27 00:00:00 | 4 | 140 | 106 | 0.32075471698113207547 |
    | 2016-10-28 00:00:00 | 7 | 147 | 112 | 0.31250000000000000000 |
    | 2016-10-29 00:00:00 | 5 | 152 | 114 | 0.33333333333333333333 |
    | 2016-10-30 00:00:00 | 5 | 157 | 119 | 0.31932773109243697479 |
    | 2016-10-31 00:00:00 | 3 | 160 | 125 | 0.28000000000000000000 |
    | (22 rows) |  |  |  |  |

    Figure C: Relative sales volume of the scooter over 3 weeks

Looking at the output table, we can see four sets of information: the daily sales count, the cumulative sum of the daily sales count, the cumulative sum offset by 1 week (the lag), and the relative daily sales volume.

**Expected Output:**

| sales\_transaction\_date | count | sum | lag | volume |
| --- | --- | --- | --- | --- |
| 2016-10-10 00:00:00 | 9 | 9 |  |  |
| 2016-10-11 00:00:00 | 6 | 15 |  |  |
| 2016-10-12 00:00:00 | 10 | 25 |  |  |
| 2016-10-13 00:00:00 | 10 | 35 |  |  |
| 2016-10-14 00:00:00 | 5 | 40 |  |  |
| 2016-10-15 00:00:00 | 10 | 50 |  |  |
| 2016-10-16 00:00:00 | 14 | 64 |  |  |
| 2016-10-17 00:00:00 | 9 | 73 | 9 | 7.1111111111111111 |
| 2016-10-18 00:00:00 | 11 | 84 | 15 | 4.6000000000000000 |
| 2016-10-19 00:00:00 | 12 | 96 | 25 | 2.8400000000000000 |
| 2016-10-20 00:00:00 | 10 | 106 | 35 | 2.0285714285714286 |
| 2016-10-21 00:00:00 | 6 | 112 | 40 | 1.8000000000000000 |
| 2016-10-22 00:00:00 | 2 | 114 | 50 | 1.2800000000000000 |
| 2016-10-23 00:00:00 | 5 | 119 | 64 | 0.85937500000000000000 |
| 2016-10-24 00:00:00 | 6 | 125 | 73 | 0.71232876712328767123 |
| 2016-10-25 00:00:00 | 9 | 134 | 84 | 0.59523809523809523810 |
| 2016-10-26 00:00:00 | 2 | 136 | 96 | 0.41666666666666666667 |
| 2016-10-27 00:00:00 | 4 | 140 | 106 | 0.32075471698113207547 |
| 2016-10-28 00:00:00 | 7 | 147 | 112 | 0.31250000000000000000 |
| 2016-10-29 00:00:00 | 5 | 152 | 114 | 0.33333333333333333333 |
| 2016-10-30 00:00:00 | 5 | 157 | 119 | 0.31932773109243697479 |
| 2016-10-31 00:00:00 | 3 | 160 | 125 | 0.28000000000000000000 |
| (22 rows) |

Figure 9.11: Relative sales volume of the Bat Scooter over 3 weeks

While the count and cumulative `sum` columns are reasonably straightforward, why do we need the `lag` and `volume` columns? This is because we are looking for drops in sales growth over the first couple of weeks, hence, we compare the daily sum of sales to the same values 7 days earlier (the lag). By subtracting the sum and lag values and dividing by the lag, we obtain the volume value and can determine sales growth compared to the previous week.

Notice that the sales volume on October 17 is 700% above that of the launch date of October 10. By October 22, the volume is over double that of the week prior. As time passes, this relative difference begins to decrease dramatically. By the end of October, the volume is 28% higher than the week prior. At this stage, we have observed and confirmed the presence of a reduction in sales growth after the first 2 weeks. The next stage is to attempt to explain the causes of the reduction.

Exercise 9.3: Launch Timing Analysis

In this exercise, we will try to identify the causes of a sales drop. Now that we have confirmed the presence of the sales growth drop, we will try to explain the cause of the event. We will test the hypothesis that the timing of the scooter launch attributed to the reduction in sales. Remember, in _Exercise 9.1, Preliminary Data Collection Using SQL Techniques_, that the ZoomZoom Bat Scooter launched on October 10, 2016. Observe the following steps to complete the exercise:

1. Load the `sqlda` database:

    ```javascript
    psql sqlda
    ```

2. Examine the other products in the database. In order to determine whether the launch date attributed to the sales drop, we need to compare the ZoomZoom Bat Scooter to other scooter products according to the launch date. Execute the following query to check the launch dates:

    ```javascript
    SELECT * FROM products;
    ```

    The following figure shows the launch dates for all the products:

    | product\_id | model | year | product\_type | base\_msrp | production\_start\_date | production\_end\_date |
    | --- | --- | --- | --- | --- | --- | --- |
    | 1 | Lemon | 2010 | scooter | 399.99 | 2010-03-03 00:00:00 | 2012-06-08 00:00:00 |
    | 2 | Lemon Limited Edition | 2011 | scooter | 799.99 | 2011-01-03 00:00:00 | 2011-03-30 00:00:00 |
    | 3 | Lemon | 2013 | scooter | 499.99 | 2013-05-01 00:00:00 | 2018-12-28 00:00:00 |
    | 4 | Model Chi | 2014 | automobile | 115,000.00 | 2014-06-23 00:00:00 | 2018-12-28 00:00:00 |
    | 5 | Blade | 2014 | scooter | 699.99 | 2014-06-23 00:00:00 | 2015-01-27 00:00:00 |
    | 6 | Model Sigma | 2015 | automobile | 65,500.00 | 2015-04-15 00:00:00 | 2018-10-01 00:00:00 |
    | 7 | Bat | 2016 | scooter | 599.99 | 2016-10-10 00:00:00 |  |
    | 8 | Bat Limited Edition | 2017 | scooter | 699.99 | 2017-02-15 00:00:00 |  |
    | 9 | Model Epsilon | 2017 | automobile | 35,000.00 | 2017-02-15 00:00:00 |  |
    | 10 | Model Gamma | 2017 | automobile | 85,750.00 | 2017-02-15 00:00:00 |  |
    | 11 | Model Chi | 2019 | automobile | 95,000.00 | 2019-02-04 00:00:00 |  |
    | 12 | Lemon Zester | 2019 | scooter | 349.99 | 2019-02-04 00:00:00 |  |
    | (12 rows) |

    Figure 9.12: Products with launch dates

    All the other products launched before July, compared to the Bat Scooter, which launched in October.
3. List all scooters from the `products` table, as we are only interested in comparing scooters:

    ```javascript
    SELECT * FROM products WHERE product_type='scooter';
    ```

    The following table shows all the information for products with the product type of `scooter`:

    | product\_id | model | year | product\_type | base\_msrp | production\_start\_date | production\_end\_date |
    | --- | --- | --- | --- | --- | --- | --- |
    | 1 | Lemon | 2010 | scooter | 399.99 | 2010-03-03 00:00:00 | 2012-06-08 00:00:00 |
    | 2 | Lemon Limited Edition | 2011 | scooter | 799.99 | 2011-01-03 00:00:00 | 2011-03-30 00:00:00 |
    | 3 | Lemon | 2013 | scooter | 499.99 | 2013-05-01 00:00:00 | 2018-12-28 00:00:00 |
    | 5 | Blade | 2014 | scooter | 699.99 | 2014-06-23 00:00:00 | 2015-01-27 00:00:00 |
    | 7 | Bat | 2016 | scooter | 599.99 | 2016-10-10 00:00:00 |  |
    | 8 | Bat Limited Edition | 2017 | scooter | 699.99 | 2017-02-15 00:00:00 |  |
    | 12 | Lemon Zester | 2019 | scooter | 349.99 | 2019-02-04 00:00:00 |  |
    | (7 rows) |

    Figure 9.13: Scooter product launch dates

    To test the hypothesis that the time of year had an impact on sales performance, we require a scooter model to use as the control or reference group. In an ideal world, we could launch the ZoomZoom Bat Scooter in a different location or region, for example, but just at a different time, and then compare the two. However, we cannot do this here. Instead, we will choose a similar scooter launched at a different time. There are several different options in the product database, each with its own similarities and differences to the experimental group (ZoomZoom Bat Scooter). In our opinion, the Bat Limited Edition Scooter is suitable for comparison (the control group). It is slightly more expensive, but it was launched only 4 months after the Bat Scooter. Looking at its name, the Bat Limited Edition Scooter seems to share most of the same features, with a number of extras given that it's a "limited edition."
4. Select the first five rows of the `sales` database:

    ```javascript
    SELECT * FROM sales LIMIT 5;
    ```

    The sales information for the first five customers is as follows:

    | customer\_id | product\_id | sales\_transaction\_date | sales\_amount | channel | dealership\_id |
    | --- | --- | --- | --- | --- | --- |
    | 1 | 7 | 2017-07-19 08:38:41 | 479.992 | internet |  |
    | 22 | 7 | 2017-08-14 09:59:02 | 599.99 | dealership | 20 |
    | 145 | 7 | 2019-01-20 10:40:11 | 479.992 | internet |  |
    | 289 | 7 | 2017-05-09 14:20:04 | 539.991 | dealership | 7 |
    | 331 | 7 | 2019-05-21 20:03:21 | 539.991 | dealership | 4 |
    | (5 rows) |

    Figure 9.14: First five rows of sales data

5. Select the `model` and `sales_transaction_date` columns from both the products and sales tables for the Bat Limited Edition Scooter. Store the results in a table, `bat_ltd_sales`, ordered by the `sales_transaction_date` column, from the earliest date to the latest:

    ```javascript
    SELECT products.model, sales.sales_transaction_date INTO bat_ltd_sales FROM sales INNER JOIN products ON sales.product_id=products.product_id WHERE sales.product_id=8 ORDER BY sales.sales_transaction_date;
    ```

6. Select the first five lines of `bat_ltd_sales`, using the following query:

    ```javascript
    SELECT * FROM bat_ltd_sales LIMIT 5;
    ```

    The following table shows the transaction details for the first five entries of `Bat Limited Edition`:

    | model | sales\_transaction\_date |
    | --- | --- |
    | Bat Limited Edition | 2017-02-15 01:49:02 |
    | Bat Limited Edition | 2017-02-15 89:42:37 |
    | Bat Limited Edition | 2017-02-15 10:48:31 |
    | Bat Limited Edition | 2017-02-15 12:22:41 |
    | Bat Limited Edition | 2017-02-15 13:51:34 |
    | (5 rows) |

    Figure 9.15: First five sales of the Bat Limited Edition Scooter

7. Calculate the total number of sales for `Bat Limited Edition`. We can check this by using the `COUNT` function:

    ```javascript
    SELECT COUNT(model) FROM bat_ltd_sales;
    ```

    The total sales count can be seen in the following figure:

    ```javascript
    count ----------- 5803 (1 row)
    ```

    Figure 9.16: Count of Bat Limited Edition sales

    This is compared to the original Bat Scooter, which sold 7,328 items.
8. Check the transaction details of the last Bat Limited Edition sale. We can check this by using the `MAX` function:

    ```javascript
    SELECT MAX(sales_transaction_date) FROM bat_ltd_sales;
    ```

    The transaction details of the last `Bat Limited Edition` product are as follows:

    ```javascript
    max ------------------- 2019-05-31 15:08:03 (1 row)
    ```

    Figure 9.17: Last date (MAX) of the Bat Limited Edition sale

9. Adjust the table to cast the transaction date column as a date, discarding the time information. As with the original Bat Scooter, we are only interested in the date of the sale, not the date and time of the sale. Write the following query:

    ```javascript
    ALTER TABLE bat_ltd_sales ALTER COLUMN sales_transaction_date TYPE date;
    ```

10. Again, select the first five records of `bat_ltd_sales`:

    ```javascript
    SELECT * FROM bat_ltd_sales LIMIT 5;
    ```

    The following table shows the first five records of `bat_ltd_sales`:

    | model | sales\_transaction\_date |
    | --- | --- |
    | Bat Limited Edition | 2017-02-15 |
    | Bat Limited Edition | 2017-02-15 |
    | Bat Limited Edition | 2017-02-15 |
    | Bat Limited Edition | 2017-02-15 |
    | Bat Limited Edition | 2017-02-15 |
    | (5 rows) |

    Figure 9.18: Select the first five Bat Limited Edition sales by date

11. In a similar manner to the standard Bat Scooter, create a count of sales on a daily basis. Insert the results into the `bat_ltd_sales_count` table by using the following query:

    ```javascript
    SELECT sales_transaction_date, count(sales_transaction_date) INTO bat_ltd_sales_count FROM bat_ltd_sales GROUP BY sales_transaction_date ORDER BY sales_transaction_date;
    ```

12. List the sales count of all the `Bat Limited` products using the following query:

    ```javascript
    SELECT * FROM bat_ltd_sales_count;
    ```
    
      
    The sales count is shown in the following figure:
    
    | sales\_transaction\_date | count |
    | --- | --- |
    | 2017-02-15 | 6 |
    | 2017-02-16 | 2 |
    | 2017-02-17 | 1 |
    | 2017-02-18 | 4 |
    | 2017-02-19 | 5 |
    | 2017-02-20 | 6 |
    | 2017-02-21 | 5 |
    | 2017-02-22 | 4 |
    | 2017-02-23 | 6 |
    | 2017-02-24 | 2 |
    | 2017-02-25 | 2 |
    | 2017-02-26 | 2 |
    | 2017-02-27 | 4 |
    | 2017-02-28 | 4 |
    | 2017-03-01 | 5 |
    | 2017-03-02 | 1 |
    
    Figure 9.19: Bat Limited Edition daily sales
    
13.  Compute the cumulative sum of the daily sales figures and insert the resulting table into `bat_ltd_sales_growth`:

    ```javascript
    SELECT *, sum(count) OVER (ORDER BY sales_transaction_date) INTO bat_ltd_sales_growth FROM bat_ltd_sales_count;
    ```
    
14.  Select the first 22 days of sales records from `bat_ltd_sales_growth`:

    ```javascript
    SELECT * FROM bat_ltd_sales_growth LIMIT 22;
    ```
    
      
    The following table displays the first 22 records of sales growth:
    
    | sales\_transaction\_date | count | sum |
    | --- | --- | --- |
    | 2017-02-15 | 6 | 6 |
    | 2017-02-16 | 2 | 8 |
    | 2017-02-17 | 1 | 9 |
    | 2017-02-18 | 4 | 13 |
    | 2017-02-19 | 5 | 18 |
    | 2017-02-20 | 6 | 24 |
    | 2017-02-21 | 5 | 29 |
    | 2017-02-22 | 4 | 33 |
    | 2017-02-23 | 6 | 39 |
    | 2017-02-24 | 2 | 41 |
    | 2017-02-25 | 2 | 43 |
    | 2017-02-26 | 2 | 45 |
    | 2017-02-27 | 4 | 49 |
    | 2017-02-28 | 4 | 53 |
    | 2017-03-01 | 5 | 58 |
    | 2017-03-02 | 1 | 59 |
    | 2017-03-03 | 3 | 62 |
    | 2017-03-04 | 8 | 70 |
    | 2017-03-05 | 4 | 74 |
    | 2017-03-06 | 7 | 81 |
    | 2017-03-07 | 7 | 88 |
    | 2017-03-08 | 8 | 96 |
    | (22 rows) |
    
    Figure 9.20: Bat Limited Edition sales – cumulative sum
    
15.  Compare this sales record with the one for the original Bat Scooter sales, as shown in the following code:

    ```javascript
    SELECT * FROM bat_sales_growth LIMIT 22;
    ```
    
      
    The following table shows the sales details for the first 22 records of the `bat_sales_growth` table:
    
    | sales\_transaction\_date | count | sum |
    | --- | --- | --- |
    | 2016-10-10 00:00:00 | 9 | 9 |
    | 2016-10-11 00:00:00 | 6 | 15 |
    | 2016-10-12 00:00:00 | 10 | 25 |
    | 2016-10-13 00:00:00 | 10 | 35 |
    | 2016-10-14 00:00:00 | 5 | 40 |
    | 2016-10-15 00:00:00 | 10 | 50 |
    | 2016-10-16 00:00:00 | 14 | 64 |
    | 2016-10-17 00:00:00 | 9 | 73 |
    | 2016-10-18 00:00:00 | 11 | 84 |
    | 2016-10-19 00:00:00 | 12 | 96 |
    | 2016-10-20 00:00:00 | 10 | 106 |
    | 2016-10-21 00:00:00 | 6 | 112 |
    | 2016-10-22 00:00:00 | 2 | 114 |
    | 2016-10-23 00:00:00 | 5 | 119 |
    | 2016-10-24 00:00:00 | 6 | 125 |
    | 2016-10-25 00:00:00 | 9 | 134 |
    | 2016-10-26 00:00:00 | 2 | 136 |
    | 2016-10-27 00:00:00 | 4 | 140 |
    | 2016-10-28 00:00:00 | 7 | 147 |
    | 2016-10-29 00:00:00 | 5 | 152 |
    | 2016-10-30 00:00:00 | 5 | 157 |
    | 2016-10-31 00:00:00 | 3 | 160 |
    | (22 rows) |
    
    Figure 9.21: Bat Scooter cumulative sales for 22 rows
    
    Sales of the limited-edition scooter did not reach double digits during the first 22 days, nor did the daily volume of sales fluctuate as much. In keeping with the overall sales figure, the limited edition sold 64 fewer units over the first 22 days.
16.  Compute the 7-day `lag` function for the `sum` column and insert the results into the `bat_ltd_sales_delay` table:

    ```javascript
    SELECT *, lag(sum , 7) OVER (ORDER BY sales_transaction_date) INTO bat_ltd_sales_delay FROM bat_ltd_sales_growth;
    ```
    
17.  Compute the sales growth for `bat_ltd_sales_delay` in a similar manner to the exercise completed in _Activity 9.1_, _Quantifying the Sales Drop_. Label the column for the results of this calculation as `volume` and store the resulting table in `bat_ltd_sales_vol`:

    ```javascript
    SELECT *, (sum-lag)/lag AS volume INTO bat_ltd_sales_vol FROM bat_ltd_sales_delay;
    ```
    
18.  Look at the first 22 records of sales in `bat_ltd_sales_vol`:

    ```javascript
    SELECT * FROM bat-ltd_sales_vol LIMIT 22;
    ```
    
      
    The sales volume can be seen in the following figure:
    
    | sales\_transaction\_date | count | sum | lag | volume |
    | --- | --- | --- | --- | --- |
    | 2017-02-15 | 6 | 6 |  |  |
    | 2017-02-16 | 2 | 8 |  |  |
    | 2017-02-17 | 1 | 9 |  |  |
    | 2017-02-18 | 4 | 13 |  |  |
    | 2017-02-19 | 5 | 18 |  |  |
    | 2017-02-20 | 6 | 24 |  |  |
    | 2017-02-21 | 5 | 29 |  |  |
    | 2017-02-23 | 4 | 33 |  |  |
    | 2017-02-24 | 2 | 41 | 9 | 3.5555555555555556 |
    | 2017-02-25 | 2 | 43 | 13 | 2.3076923076923077 |
    | 2017-02-26 | 2 | 45 | 18 | 1.5000000000000000 |
    | 2017-02-27 | 4 | 49 | 24 | 1.0416666666666667 |
    | 2017-02-28 | 4 | 53 | 29 | 0.82758620689655172414 |
    | 2017-03-01 | 5 | 58 | 33 | 0.75757575757575757576 |
    | 2017-03-02 | 1 | 59 | 39 | 0.51282051282051282051 |
    | 2017-03-03 | 3 | 62 | 41 | 0.51219512195121951220 |
    | 2017-03-04 | 8 | 70 | 43 | 0.62790697674418604651 |
    | 2017-03-05 | 4 | 74 | 45 | 0.64444444444444444444 |
    | 2017-03-06 | 7 | 81 | 49 | 0.65306122448979591837 |
    | 2017-03-07 | 7 | 88 | 53 | 0.66037735849056603774 |
    | 2017-03-08 | 8 | 96 | 58 | 0.65517241379310344828 |
    | (22 rows) |
    
    Figure 9.22: Bat Scooter cumulative sales showing volume
    

Looking at the `volume` column in the preceding diagram, we can again see that the sales growth is more consistent than the original Bat Scooter. The growth within the first week is less than that of the original model, but it is sustained over a longer period. After 22 days of sales, the sales growth of the limited-edition scooter is 65% compared to the previous week, as compared with the 28% growth identified in the second activity of the lesson.

At this stage, we have collected data from two similar products launched at different time periods and found some differences in the trajectory of the sales growth over the first 3 weeks of sales. In a professional setting, we may also consider employing more sophisticated statistical comparison methods, such as tests for differences of mean, variance, survival analysis, or other techniques. These methods lie outside the scope of this course and, as such, limited comparative methods will be used.

While we have shown there to be a difference in sales between the two Bat Scooters, we also cannot rule out the fact that the sales differences can be attributed to the difference in the sales price of the two scooters, with the limited-edition scooter being $100 more expensive. In the next activity, we will compare the sales of the Bat Scooter to the 2013 Lemon, which is $100 cheaper, was launched 3 years prior, is no longer in production, and started production in the first half of the calendar year.

Activity 9.2: Analyzing the Difference in the Sales Price Hypothesis

In this activity, we are going to investigate the hypothesis that the reduction in sales growth can be attributed to the price point of the Bat Scooter. Previously, we considered the launch date. However, there could be another factor – the sales price included. If we consider the product list of scooters shown in _Figure 9.23_, and exclude the Bat model scooter, we can see that there are two price categories, $699.99 and above, or $499.99 and below. The Bat Scooter sits exactly between these two groups; perhaps the reduction in sales growth can be attributed to the different pricing model. In this activity, we will test this hypothesis by comparing Bat sales to the 2013 Lemon:

| product\_id | model | year | product\_type | base\_msrp | production\_start\_date | production\_end\_date |
| --- | --- | --- | --- | --- | --- | --- |
| 12 | Lemon Zester | 2019 | scooter | 349.99 | 2019-02-04 00:00:00 |  |
| 1 | Lemon | 2010 | scooter | 399.99 | 2010-03-03 00:00:00 | 2012-06-08 00:00:00 |
| 3 | Lemon | 2013 | scooter | 499.99 | 2013-05-01 00:00:00 | 2018-12-28 00:00:00 |
| 7 | Bat | 2016 | scooter | 599.99 | 2016-10-10 00:00:00 |  |
| 5 | Blade | 2014 | scooter | 699.99 | 2014-06-23 00:00:00 | 2015-01-27 00:00:00 |
| 8 | Bat Limited Edition | 2017 | scooter | 699.99 | 2017-02-15 00:00:00 |  |
| 2 | Lemon Limited Edition | 2011 | scooter | 799.99 | 2011-01-03 00:00:00 | 2011-03-30 00:00:00 |
| (7 rows) |

Figure 9.23: List of scooter models

The following are the steps to perform:

1. Load the `sqlda` database from the accompanying source code located at this [link](https://github.com/TrainingByPackt/SQL-for-Data-Analytics/tree/master/Datasets).
2. Select the `sales_transaction_date` column from the year 2013 for `Lemon` model sales and insert the column into a table called `lemon_sales`.
3. Count the sales records available for 2013 for the `Lemon` model.
4. Display the latest `sales_transaction_date` column.
5. Convert the `sales_transaction_date` column to a date type.
6. Count the number of sales per day within the `lemon_sales` table and insert the data into a table called `lemon_sales_count`.
7. Calculate the cumulative sum of sales and insert the corresponding table into a new table labeled `lemon_sales_sum`.
8. Compute the 7-day `lag` function on the `sum` column and save the result to `lemon_sales_delay`.
9. Calculate the growth rate using the data from `lemon_sales_delay` and store the resulting table in `lemon_sales_growth`.
10. Inspect the first 22 records of the `lemon_sales_growth` table by examining the `volume` data.

**Solution**

1. Load the sqlda database:

    ```javascript
    psql sqlda
    ```

2. Select the sales\_transaction\_date column from the 2013 Lemon sales and insert the column into a table called lemon\_sales:

    ```javascript
    SELECT sales_transaction_date INTO lemon_sales FROM sales WHERE product_id=3;
    ```

3. Count the sales records available for the 2013 Lemon by running the following query:

    ```javascript
    SELECT count(sales_transaction_date) FROM lemon_sales;
    ```

    We can see that **16558** records are available:

    ```javascript
    count -------------------- 16558 (1 row)
    ```

    Figure A: Sales records for the 2013 Lemon Scooter

4. Use the max function to check the latest sales\_transaction\_date column:

    ```javascript
    SELECT max(sales_transaction_date) FROM lemon_sales;
    ```

    The following figure displays the sales\_transaction\_date column:

    ```javascript
    max ---------------- 2018-12-27 19:12:!0 (1 row)
    ```

    Figure B: Production between May 2013 and December 2018

5. Convert the sales\_transaction\_date column to a date type using the following query:

    ```javascript
    ALTER TABLE lemon_sales ALTER COLUMN sales_transaction_date TYPE DATE;
    ```

    We are converting the datatype from DATE\_TIME to DATE so as to remove the time information from the field. We are only interested in accumulating numbers, but just the date and not the time. Hence, it is easier just to remove the time information from the field.
6. Count the number of sales per day within the lemon\_sales table and insert this figure into a table called lemon\_sales\_count:

    ```javascript
    SELECT *, COUNT(sales_transaction_date) INTO lemon_sales_count FROM lemon_sales GROUP BY sales_transaction_date,lemon_sales.customer_id ORDER BY sales_transaction_date;
    ```

7. Calculate the cumulative sum of sales and insert the corresponding table into a new table labeled lemon\_sales\_sum:

    ```javascript
    SELECT *, sum(count) OVER (ORDER BY sales_transaction_date) INTO lemon_sales_sum FROM lemon_sales_count;
    ```

8. Compute the 7-day lag function on the sum column and save the result to lemon\_sales\_delay:

    ```javascript
    SELECT *, lag(sum, 7) OVER (ORDER BY sales_transaction_date) INTO lemon_sales_delay FROM lemon_sales_sum;
    ```

9. Calculate the growth rate using the data from lemon\_sales\_delay and store the resulting table in lemon\_sales\_growth. Label the growth rate column as volume:

    ```javascript
    SELECT *, (sum-lag)/lag AS volume INTO lemon_sales_growth FROM lemon_sales_delay;
    ```

10. Inspect the first 22 records of the lemon\_sales\_growth table by examining the volume data:

    ```javascript
    SELECT * FROM lemon_sales_growth LIMIT 22;
    ```

    The following table shows the sales growth:

    | sales\_transaction\_date | count | sum | lag | volume |
    | --- | --- | --- | --- | --- |
    | 2013-05-01 | 6 | 6 |  |  |
    | 2013-05-02 | 8 | 14 |  |  |
    | 2013-05-03 | 4 | 18 |  |  |
    | 2013-05-04 | 9 | 27 |  |  |
    | 2013-05-05 | 9 | 36 |  |  |
    | 2013-05-06 | 6 | 42 |  |  |
    | 2013-05-07 | 8 | 50 |  |  |
    | 2013-05-08 | 6 | 56 | 6 | 8.3333333333333333 |
    | 2013-05-09 | 6 | 62 | 14 | 3.4285714285714286 |
    | 2013-05-10 | 9 | 71 | 18 | 2.9444444444444444 |
    | 2013-05-11 | 3 | 74 | 27 | 1.7407407407407407 |
    | 2013-05-12 | 4 | 78 | 36 | 1.1666666666666667 |
    | 2013-05-13 | 7 | 85 | 42 | 1.0238095238095238 |
    | 2013-05-14 | 3 | 88 | 50 | 0.76000000000000000000 |
    | 2013-05-15 | 3 | 91 | 56 | 0.62500000000000000000 |
    | 2013-05-16 | 4 | 95 | 62 | 0.53225806451612903226 |
    | 2013-05-17 | 6 | 101 | 71 | 0.42253521126760563380 |
    | 2013-05-18 | 9 | 110 | 74 | 0.48648648648648648649 |
    | 2013-05-19 | 6 | 116 | 78 | 0.48717948717948717949 |
    | 2013-05-20 | 6 | 122 | 85 | 0.43529411764705882353 |
    | 2013-05-21 | 11 | 133 | 88 | 0.51136363636363636364 |
    | 2013-05-22 | 8 | 141 | 91 | 0.54945054945054945055 |
    | (22 rows) |

    Figure C: Sales growth of the Lemon Scooter

Similar to the previous exercise, we have calculated the cumulative sum, lag, and relative sales growth of the Lemon Scooter. We can see that the initial sales volume is much larger than the other scooters, at over 800%, and again finishes higher at 55%

**Expected Output:**

| sales\_transaction\_date | count | sum | lag | volume |
| --- | --- | --- | --- | --- |
| 2013-05-01 6 | 6 | 6 |  |  |
| 2013-05-02 | 8 | 14 |  |  |
| 2013-05-03 | 4 | 18 |  |  |
| 2013-05-04 | 9 | 27 |  |  |
| 2013-05-05 | 9 | 36 |  |  |
| 2013-05-06 | 6 | 42 |  |  |
| 2013-05-07 | 8 | 50 |  |  |
| 2013-05-08 | 6 | 56 | 6 | 8.3333333333333333 |
| 2013-05-09 | 6 | 62 | 14 | 3.4285714285714286 |
| 2013-05-10 | 9 | 71 | 18 | 2.9444444444444444 |
| 2013-05-11 | 3 | 74 | 27 | 1.7407407407407407 |
| 2013-05-12 | 4 | 78 | 36 | 1.1666666666666667 |
| 2013-05-13 | 7 | 85 | 42 | 1.0238095238095238 |
| 2013-05-14 | 3 | 88 | 50 | 0.76000000000000000000 |
| 2013-05-15 | 3 | 91 | 56 | 0.62500000000000000000 |
| 2013-05-16 | 4 | 95 | 62 | 0.53225806451612903226 |
| 2013-05-17 | 6 | 101 | 71 | 0.42253521126760563380 |
| 2013-05-18 | 9 | 110 | 74 | 0.48648648648648648649 |
| 2013-05-19 | 6 | 116 | 78 | 0.48717948717948717949 |
| 2013-05-20 | 6 | 122 | 85 | 0.43529411764705882353 |
| 2013-05-21 | 11 | 133 | 88 | 0.51136363636363636364 |
| 2013-05-22 | 8 | 141 | 91 | 0.54945054945054945055 |
| (22 rows) |

Figure 9.54: Sales growth of the Lemon Scooter

Now that we have collected data to test the two hypotheses of timing and cost, what observations can we make and what conclusions can we draw? The first observation that we can make is regarding the total volume of sales for the three different scooter products. The Lemon Scooter, over its production life cycle of 4.5 years, sold 16,558 units, while the two Bat Scooters, the Original and Limited Edition models, sold 7,328 and 5,803 units, respectively, and are still currently in production, with the Bat Scooter launching about 4 months earlier and with approximately 2.5 years of sales data available. Looking at the sales growth of the three different scooters, we can also make a few different observations:

- The original Bat Scooter, which launched in October at a price of $599.99, experienced a 700% sales growth in its second week of production and finished the first 22 days with 28% growth and a sales figure of 160 units.
- The Bat Limited Edition Scooter, which launched in February at a price of $699.99, experienced 450% growth at the start of its second week of production and finished with 96 sales and 66% growth over the first 22 days.
- The 2013 Lemon Scooter, which launched in May at a price of $499.99, experienced 830% growth in the second week of production and ended its first 22 days with 141 sales and 55% growth.

Based on this information, we can make a number of different conclusions:

- The initial growth rate starting in the second week of sales correlates to the cost of the scooter. As the cost increased to $699.99, the initial growth rate dropped from 830% to 450%.
- The number of units sold in the first 22 days does not directly correlate to the cost. The $599.99 Bat Scooter sold more than the 2013 Lemon Scooter in that first period despite the price difference.
- There is some evidence to suggest that the reduction in sales can be attributed to seasonal variations given the significant reduction in growth and the fact that the original Bat Scooter is the only one released in October. So far, the evidence suggests that the drop can be attributed to the difference in launch timing.

Before we draw the conclusion that the difference can be attributed to seasonal variations and launch timing, let's ensure that we have extensively tested a range of possibilities. Perhaps marketing work, such as email campaigns, that is, when the emails were sent, and the frequency with which the emails were opened, made a difference.

Now that we have considered both the launch timing and the suggested retail price of the scooter as a possible cause of the reduction in sales, we will direct our efforts to other potential causes, such as the rate of opening of marketing emails. Does the marketing email opening rate have an effect on sales growth throughout the first 3 weeks? We will find this out in our next exercise.

Exercise 9.4: Analyzing Sales Growth by Email Opening Rate

In this exercise, we will analyze the sales growth using the email opening rate. To investigate the hypothesis that a decrease in the rate of opening emails impacted the Bat Scooter sales rate, we will again select the Bat and Lemon Scooters and will compare the email opening rate.

Perform the following steps to complete the exercise:

1. Load the `sqlda` database:

    ```javascript
    psql sqlda
    ```

2. Firstly, look at the `emails` table to see what information is available. Select the first five rows of the `emails` table:

    ```javascript
    SELECT * FROM emails LIMIT 5;
    ```

    The following table displays the email information for the first five rows:

    | email\_id | customer\_id | email\_subject | opened | clicked | bounced | sent\_date | opened\_date | clicked\_date |
    | --- | --- | --- | --- | --- | --- | --- | --- | --- |
    | 1 | 18 | Introducing A Limited Edition | f | f | f | 2011-01-03 15:00:00 |  |  |
    | 2 | 30 | Introducing A Limited Edition | f | f | f | 2011-01-03 15:00:00 |  |  |
    | 3 | 41 | Introducing A Limited Edition | t | f | f | 2011-01-03 15:00:00 | 2011-01-04 10:41:11 |  |
    | 4 | 52 | Introducing A Limited Edition | f | f | f | 2011-01-03 15:00:00 |  |
    | 5 | 59 | Introducing A Limited Edition | f | f | f | 2011-01-03 15:00:00 |  |  |
    | (5 rows) |

    Figure 9.55: Sales growth of the Lemon Scooter

    To investigate our hypothesis, we need to know whether an email was opened, and when it was opened, as well as who the customer was who opened the email and whether that customer purchased a scooter. If the email marketing campaign was successful in maintaining the sales growth rate, we would expect a customer to open an email soon before a scooter was purchased.

    The period in which the emails were sent, as well as the ID of customers who received and opened an email, can help us to determine whether a customer who made a sale may have been encouraged to do so following the receipt of an email.

3. To determine the hypothesis, we need to collect the `customer_id` column from both the `emails` table and the `bat_sales` table for the Bat Scooter, the `opened`, `sent_date`, `opened_date`, and `email_subject` columns from `emails` table, as well as the `sales_transaction_date` column from the `bat_sales` table. As we only want the email records of customers who purchased a Bat Scooter, we will join the `customer_id` column in both tables. Then, insert the results into a new table – `bat_emails`:

    ```javascript
    SELECT emails.email_subject, emails.customer_id, emails.opened, emails.sent_date, emails.opened_date, bat_sales.sales_transaction_date INTO bat_emails FROM emails INNER JOIN bat_sales ON bat_sales.customer_id=emails.customer_id ORDER BY bat_sales.sales_transaction_date;
    ```

4. Select the first 10 rows of the `bat_emails` table, ordering the results by `sales_transaction_date`:

    ```javascript
    SELECT * FROM bat_emails LIMIT 10;
    ```

    The following table shows the first 10 rows of the `bat_emails` table ordered by `sales_transaction_date`:

    | email\_subject | customer\_id | opened | sent\_date | opened\_date | sales\_transaction\_date |
    | --- | --- | --- | --- | --- | --- |
    | A New Year, And Some New EVs | 11678 | f | 2019-01-07 15:00:00 |  | 2016-10-10 00:00:00 |
    | A Brand New Scooter...and Car | 40250 | f | 2014-05-06 15:00:00 |  | 2016-10-10 00:00:00 |
    | We Really Outdid Ourselves this Year | 24125 | f | 2017-01-15 15:00:00 |  | 2016-10-10 00:00:00 |
    | Tis' the Season for Savings | 31307 | t | 2015-11-26 15:00:00 | 2015-11-27 04:55:07 | 2016-10-10 00:06:00 |
    | 25% off all EVs. Its a Christmas Miracle! | 42213 | f | 2016-11-25 15:00:00 |  | 2016-10-10 00:00:00 |
    | Zoom zoom Black Friday Sale | 40250 | f | 2014-11-28 15:00:00 |  | 2016-10-10 00:00:00 |
    | Save the Planet with same Holiday Savings. | 4553 | f | 2016-11-23 15:00:00 |  | 2016 10 10 00:00:00 |
    | The 2013 Lemon Scooter is Here | 24125 | t | 2013-03-01 15:00:00 | 2013-03-02 14:43:34 | 2016 10 10 00:00:00 |
    | The 2013 Lemon Scooter is Here | 40250 | f | 2013-03-01 15:00:00 |  | 2016-10-10 00:00:00 |
    | Save the Planet with some Holiday Savings. | 40250 | f | 2018-11-23 15:00:00 |  | 2016-10-10 00:00:00 |
    | (10 rows) |

    Figure 9.56: Email and sales information joined on customer\_id

    We can see here that there are several emails unopened, over a range of sent dates, and that some customers have received multiple emails. Looking at the subjects of the emails, some of them don't seem related to the Zoom scooters at all.
5. Select all rows where the `sent_date` email predates the `sales_transaction_date` column, order by `customer_id`, and limit the output to the first 22 rows. This will help us to know which emails were sent to each customer before they purchased their scooter. Write the following query to do so:

    ```javascript
    SELECT * FROM bat_emails WHERE sent_date < sales_transaction_date ORDER BY customer_id LIMIT 22;
    ```

    The following table lists the emails sent to the customers before the `sales_transaction_date` column:

    ![The figure shows the output of the above query. ](https://s3.amazonaws.com/jigyaasa_content_static/sql-data-anal/C11861_09_27.jpg)

    Figure 9.57: Emails sent to customers before the sale transaction date

6. Delete the rows of the `bat_emails` table where emails were sent more than 6 months prior to production. As we can see, there are some emails that were sent years before the transaction date. We can easily remove some of the unwanted emails by removing those sent before the Bat Scooter was in production. From the products table, the production start date for the Bat Scooter is October 10, 2016:

    ```javascript
    DELETE FROM bat_emails WHERE sent_date < '2016-04-10';
    ```

    Note

    In this exercise, we are removing information that we no longer require from an existing table. This differs from the previous exercises, where we created multiple tables each with slightly different information from other. The technique you apply will differ depending upon the requirements of the problem being solved; do you require a traceable record of analysis, or is efficiency and reduced storage key?

7. Delete the rows where the sent date is after the purchase date, as they are not relevant to the sale:

    ```javascript
    DELETE FROM bat_emails WHERE sent_date > sales_transaction_date;
    ```

8. Delete those rows where the difference between the transaction date and the sent date exceeds 30, as we also only want those emails that were sent shortly before the scooter purchase. An email 1 year beforehand is probably unlikely to influence a purchasing decision, but one closer to the purchase date may have influenced the sales decision. We will set a limit of 1 month (30 days) before the purchase. Write the following query to do so:

    ```javascript
    DELETE FROM bat_emails WHERE (sales_transaction_date-sent_date) > '30 days';
    ```

9. Examine the first 22 rows again ordered by `customer_id` by running the following query:

    ```javascript
    SELECT * FROM bat_emails ORDER BY customer_id LIMIT 22;
    ```

    The following table shows the emails where the difference between the transaction date and the sent date is less than 30:

    ![The figure shows the output of the above query.](https://s3.amazonaws.com/jigyaasa_content_static/sql-data-anal/C11861_09_28.jpg)

    Figure 9.58: Emails sent close to the date of sale

    At this stage, we have reasonably filtered the available data based on the dates the email was sent and opened. Looking at the preceding `email_subject` column, it also appears that there are a few emails unrelated to the Bat Scooter, for example, **25% of all EVs. It's a Christmas Miracle!** and **Black Friday. Green Cars**. These emails seem more related to electric car production instead of scooters, and so we can remove them from our analysis.
10. Select the distinct value from the `email_subject` column to get a list of the different emails sent to the customers:

    ```javascript
    SELECT DISTINCT(email_subject) FROM bat_emails;
    ```

    The following table shows a list of distinct email subjects:

    ```javascript
    email subject --------------------------------------- Black Friday. Green Cars. 25% off all EVs. It's a Christmas Miracle! A New Year, And Some New EVs Like a Bat out of Heaven Save the Planet with sme Holiday Savings. We Really Outdid Ourselves this Year (6 rows)
    ```

    Figure 9.59: Unique email subjects sent to potential customers of the Bat Scooter

11. Delete all records that have `Black Friday` in the email subject. These emails do not appear relevant to the sale of the Bat Scooter:

    ```javascript
    DELETE FROM bat_emails WHERE position('Black Friday' in email_subject)>0;
    ```

    Note

    The `position` function in the preceding example is used to find any records where the `Black Friday` string is at the first character in the mail or more in `email_structure`. Thus, we are deleting any rows where `Black Friday` is in the email subject. For more information on PostgreSQL, refer to the documentation regarding [string functions](https://www.postgresql.org/docs/current/functions-string.html).

12. Delete all rows where **25% off all EVs. It's a Christmas Miracle!** and **A New Year, And Some New EVs** can be found in the `email_subject`:

    ```javascript
    DELETE FROM bat_emails WHERE position('25% off all EV' in email_subject)>0; DELETE FROM bat_emails WHERE position('Some New EV' in email_subject)>0;
    ```
    
13.  At this stage, we have our final dataset of emails sent to customers. Count the number of rows that are left in the sample by writing the following query:

    ```javascript
    SELECT count(sales_transaction_date) FROM bat_emails;
    ```
    
      
    We can see that **401** rows are left in the sample:
    
    ```javascript
    count ----------- 401 (1 row)
    ```
    
    Figure 9.60: Count of the final Bat Scooter email dataset
    
14.  We will now compute the percentage of emails that were opened relative to sales. Count the emails that were opened by writing the following query:

    ```javascript
    SELECT count(opened) FROM bat_emails WHERE opened='t'
    ```
    
      
    We can see that **98** emails were opened:
    
    ```javascript
    count ------------ 98 (1 row)
    ```
    
    Figure 9.61: Count of opened Bat Scooter campaign emails
    
15.  Count the customers who received emails and made a purchase. We will determine this by counting the number of unique (or distinct) customers that are in the `bat_emails` table:

    ```javascript
    SELECT COUNT(DISTINCT(customer_id)) FROM bat_emails;
    ```
    
      
    We can see that **396** customers who received an email made a purchase:
    
    ```javascript
    count ----------- 396 (1 row)
    ```
    
    Figure 9.62: Count of unique customers who received a Bat Scooter campaign email
    
16.  Count the unique (or distinct) customers who made a purchase by writing the following query:

    ```javascript
    SELECT COUNT(DISTINCT(customer_id)) FROM bat_sales;
    ```
    
      
    Following is the output of the preceding code:
    
    ```javascript
    count ---------- 6659 (1 row)
    ```
    
    Figure 9.63: Count of unique customers
    
17.  Calculate the percentage of customers who purchased a Bat Scooter after receiving an email:

    ```javascript
    SELECT 396.0/6659.0 AS email_rate;
    ```
    
      
    The output of the preceding query is displayed as follows:
    
    ```javascript
    email_rate ---------------------- 0.05946838864694398558 (1 row)
    ```
    
    Figure 9.64: Percentage of customers who received an email
    
    Note
    
    In the preceding calculation, you can see that we included a decimal place in the figures, for example, 396.0 instead of a simple integer value (396). This is because the resulting value will be represented as less than 1 percentage point. If we excluded these decimal places, the SQL server would have completed the division operation as integers and the result would be 0.
    
    Just under 6% of customers who made a purchase received an email regarding the Bat Scooter. Since 18% of customers who received an email made a purchase, there is a strong argument to be made that actively increasing the size of the customer base who receive marketing emails could increase Bat Scooter sales.
18.  Limit the scope of our data to be all sales prior to November 1, 2016 and put the data in a new table called `bat_emails_threewks`. So far, we have examined the email opening rate throughout all available data for the Bat Scooter. Check the rate throughout for the first 3 weeks, where we saw a reduction in sales:

    ```javascript
    SELECT * INTO bat_emails_threewks FROM bat_emails WHERE sales_transaction_date < '2016-11-01';
    ```
    
19.  Now, count the number of emails opened during this period:

    ```javascript
    SELECT COUNT(opened) FROM bat_emails_threewks;
    ```
    
      
    We can see that we have sent **82** emails during this period:
    
    ```javascript
    count ---------------------- 82 (1 row)
    ```
    
    Figure 9.65: Count of emails opened in the first 3 weeks
    
20.  Now, count the number of emails opened in the first 3 weeks:

    ```javascript
    SELECT COUNT(opened) FROM bat_emails_threewks WHERE opened='t';
    ```
    
      
    The following is the output of the preceding code:
    
    ```javascript
    count ---------------------- 15 (1 row)
    ```
    
    Figure 9.66: Count of emails opened
    
      
    We can see that **15** emails were opened in the first 3 weeks.
21.  Count the number of customers who received emails during the first 3 weeks of sales and who then made a purchase by using the following query:

    ```javascript
    SELECT COUNT(DISTINCT(customer_id)) FROM bat_emails_threewks;
    ```
    
      
    We can see that **82** customers received emails during the first 3 weeks:
    
    ```javascript
    count ---------------------- 82 (1 row)
    ```
    
    Figure 9.67: Customers who made a purchase in the first 3 weeks
    
22.  Calculate the percentage of customers who opened emails pertaining to the Bat Scooter and then made a purchase in the first 3 weeks by using the following query:

    ```javascript
    SELECT 15.0/82.0 AS sale_rate;
    ```
    
      
    The following table shows the calculated percentage:
    
    ```javascript
    sale_rate 0.18292682926829268293 (1 row)
    ```
    
    Figure 9.68: Percentage of customers in the first 3 weeks who opened emails
    
      
    Approximately 18% of customers who received an email about the Bat Scooter made a purchase in the first 3 weeks. This is consistent with the rate for all available data for the Bat Scooter.
23.  Calculate how many unique customers we have in total throughout the first 3 weeks. This information is useful context when considering the percentages, we just calculated. 3 sales out of 4 equate to 75% but, in this situation, we would prefer a lower rate of the opening but for a much larger customer base. Information on larger customer bases is generally more useful as it is typically more representative of the entire customer base, rather than a small sample of it. We already know that 82 customers received emails:

    ```javascript
    SELECT COUNT(DISTINCT(customer_id)) FROM bat_sales WHERE sales_transaction_date < '2016-11-01';
    ```
    
      
    The following output reflects **160** customers where the transaction took place before November 1, 2016:
    
    ```javascript
    count ------------ 160 (1 row)
    ```
    
    Figure 9.69: Number of distinct customers from bat\_sales
    

There were 160 customers in the first 3 weeks, 82 of whom received emails, which is slightly over 50% of customers. This is much more than 6% of customers over the entire period of availability of the scooter.

Now that we have examined the performance of the email marketing campaign for the Bat Scooter, we need a control or comparison group to establish whether the results were consistent with that of other products. Without a group to compare against, we simply do not know whether the email campaign of the Bat Scooter was good, bad, or neither. We will perform the next exercise to investigate performance.

Exercise 9.5: Analyzing the Performance of the Email Marketing Campaign

In this exercise, we will investigate the performance of the email marketing campaign for the Lemon Scooter to allow for a comparison with the Bat Scooter. Our hypothesis is that if the email marketing campaign performance of the Bat Scooter is consistent with another, such as the 2013 Lemon, then the reduction in sales cannot be attributed to differences in the email campaigns.

Perform the following steps to complete the exercise:

1. Load the `sqlda` database:

    ```javascript
    psql sqlda
    ```

2. Drop the existing `lemon_sales` table:

    ```javascript
    DROP TABLE lemon_sales;
    ```

3. The 2013 Lemon Scooter is `product_id = 3`. Select `customer_id` and `sales_transaction_date` from the sales table for the 2013 Lemon Scooter. Insert the information into a table called `lemon_sales`:

    ```javascript
    SELECT customer_id, sales_transaction_date INTO lemon_sales FROM sales WHERE product_id=3;
    ```

4. Select all information from the `emails` database for customers who purchased a 2013 Lemon Scooter. Place the information in a new table called `lemon_emails`:

    ```javascript
    SELECT emails.customer_id, emails.email_subject, emails.opened, emails.sent_date, emails.opened_date, lemon_sales.sales_transaction_date INTO lemon_emails FROM emails INNER JOIN lemon_sales ON emails.customer_id=lemon_sales.customer_id;
    ```

5. Remove all emails sent before the start of production of the 2013 Lemon Scooter. For this, we first require the date when production started:

    ```javascript
    SELECT production_start_date FROM products Where product_id=3;
    ```

    The following table shows the `production_start_date` column:

    ```javascript
    production_start_data --------------------------------- 2013-5-01 00:00:00 (1 row)
    ```

    Figure 9.70: Production start date of the Lemon Scooter

    Now, delete the emails that were sent before the start of production of the 2013 Lemon Scooter:

    ```javascript
    DELETE FROM lemon_emails WHERE sent_date < '2013-05-01';
    ```

6. Remove all rows where the sent date occurred after the `sales_transaction_date` column:

    ```javascript
    DELETE FROM lemon_emails WHERE sent_date > sales_transaction_date;
    ```

7. Remove all rows where the sent date occurred more than 30 days before the `sales_transaction_date` column:

    ```javascript
    DELETE FROM lemon_emails WHERE (sales_transaction_date - sent_date) > '30 days';
    ```

8. Remove all rows from `lemon_emails` where the email subject is not related to a Lemon Scooter. Before doing this, we will search for all distinct emails:

    ```javascript
    SELECT DISTINCT(email_subject) FROM lemon_emails;
    ```

    The following table shows the distinct email subjects:

    ```javascript
    email_subject ---------------------------------------------------------- Tis' the Season for Savings 25% off all EVs. It's a Christmas Miracle! A Brand New Scooter...and Car Like a Bat out of Heaven Save the Planet with some Holiday Savings. Shocking Holiday Savings on Electric Scooters An Electric Car fr a New Age We cut you a deal: 20% off a Blade Black Friday. Green Cars. Zoom Zoom Back Friday Sale (11 rows)
    ```

    Figure 9.71: Lemon Scooter campaign emails sent

    Now, delete the email subject not related to the Lemon Scooter using the `DELETE` command:

    ```javascript
    DELETE FROM lemon_emails WHERE POSITION('25% off all EVs.' in email_subject)>0; DELETE FROM lemon_emails WHERE POSITION('Like a Bat out of Heaven' in email_subject)>0; DELETE FROM lemon_emails WHERE POSITION('Save the Planet' in email_subject)>0; DELETE FROM lemon_emails WHERE POSITION('An Electric Car' in email_subject)>0; DELETE FROM lemon_emails WHERE POSITION('We cut you a deal' in email_subject)>0; DELETE FROM lemon_emails WHERE POSITION('Black Friday. Green Cars.' in email_subject)>0; DELETE FROM lemon_emails WHERE POSITION('Zoom' in email_subject)>0;
    ```

9. Now, check how many emails of `lemon_scooter` customers were opened:

    ```javascript
    SELECT COUNT(opened) FROM lemon_emails WHERE opened='t';
    ```

    We can see that **128** emails were opened:

    ```javascript
    count --------- 128 (1 rows)
    ```

    Figure 9.72: Lemon Scooter campaign emails opened

10. List the number of customers who received emails and made a purchase:

    ```javascript
    SELECT COUNT(DISTINCT(customer_id)) FROM lemon_emails;
    ```

    The following figure shows that **506** customers made a purchase after receiving emails:

    ```javascript
    count --------- 506 (1 rows)
    ```

    Figure 9.73: Unique customers who purchased a Lemon Scooter

11. Calculate the percentage of customers who opened the received emails and made a purchase:

    ```javascript
    SELECT 128.0/506.0 AS email_rate;
    ```

    We can see that 25% of customers opened the emails and made a purchase:

    ```javascript
    email_rate ------------------------------- 0.25296442687747035573 (1 row)
    ```

    Figure 9.74: Lemon Scooter customer email rate

12. Calculate the number of unique customers who made a purchase:

    ```javascript
    SELECT COUNT(DISTINCT(customer_id)) FROM lemon_sales;
    ```
    
      
    We can see that **13854** customers made a purchase:
    
    ```javascript
    count ------------------------------- 13854 (1 row)
    ```
    
    Figure 9.75: Count of unique Lemon Scooter customers
    
13.  Calculate the percentage of customers who made a purchase having received an email. This will enable a comparison with the corresponding figure for the Bat Scooter:

    ```javascript
    SELECT 506.0/13854.0 AS email_sales;
    ```
    
      
    The preceding calculation generates a 36% output:
    
    ```javascript
    email_sales ------------------------- 0.03652374765410711708 (1 row)
    ```
    
    Figure 9.76: Lemon Scooter customers who received an email
    
14.  Select all records from `lemon_emails` where a sale occurred within the first 3 weeks of the start of production. Store the results in a new table – `lemon_emails_threewks`:

    ```javascript
    SELECT * INTO lemon_emails_threewks FROM lemon_emails WHERE sales_transaction_date < '2013-06-01';
    ```
    
15.  Count the number of emails that were made for Lemon Scooters in the first 3 weeks:

    ```javascript
    SELECT COUNT(sales_transaction_date) FROM lemon_emails_threewks;
    ```
    
      
    The following is the output of the preceding code:
    
    ```javascript
    count ----------- 0 (1 row)
    ```
    
    Figure 9.77: Unique sales of the Lemon Scooter in the first 3 weeks
    

There is a lot of interesting information here. We can see that 25% of customers who opened an email made a purchase, which is a lot higher than the 18% figure for the Bat Scooter. We have also calculated that just over 3.6% of customers who purchased a Lemon Scooter were sent an email, which is much lower than the almost 6% of Bat Scooter customers. The final interesting piece of information we can see is that none of the Lemon Scooter customers received an email during the first 3 weeks of product launch compared with the 82 Bat Scooter customers, which is approximately 50% of all customers in the first 3 weeks!

In this exercise, we investigated the performance of an email marketing campaign for the Lemon Scooter to allow for a comparison with the Bat Scooter using various SQL techniques.
