/*

More advanced SQL

------------------------------------------------------------------------------------------------

HOW TO GET THE SCHEMA OF A DATABASE: 
* Windows/Linux: Ctrl + r
* MacOS: Cmd + r

*/

/**************************
***************************
CHALLENGES
***************************
**************************/

-- In SQL we can have many databases, they will show up in the schemas list
-- We must first define which database we will be working with
USE publications; 
 
/**************************
ALIAS
**************************/
-- https://www.w3schools.com/sql/sql_alias.asp

-- 1. From the sales table, change the column name qty to Quantity
SELECT 
    *, qty AS 'Quantity'
FROM
    sales;

-- 2. Assign a new name into the table sales. Select the column order number using the table alias
SELECT 
    s.ord_num
FROM
    sales AS s;

/**************************
JOINS
**************************/
-- https://www.w3schools.com/sql/sql_join.asp

/* We will only use LEFT, RIGHT, and INNER joins this week
You do not need to worry about the other types for now */

-- LEFT JOIN example
-- https://www.w3schools.com/sql/sql_join_left.asp
SELECT 
    *
FROM
    stores s
        LEFT JOIN
    discounts d ON d.stor_id = s.stor_id;

-- RIGHT JOIN example
-- https://www.w3schools.com/sql/sql_join_right.asp
SELECT 
    *
FROM
    stores s
        RIGHT JOIN
    discounts d ON d.stor_id = s.stor_id;

-- INNER JOIN example
-- https://www.w3schools.com/sql/sql_join_inner.asp
SELECT 
    *
FROM
    stores s
        INNER JOIN
    discounts d ON d.stor_id = s.stor_id;

-- 3. Using LEFT JOIN: in which cities has "Is Anger the Enemy?" been sold?
-- HINT: you can add WHERE function after the joins
SELECT DISTINCT
    (st.city)
FROM
    titles AS t
        LEFT JOIN
    sales AS s ON t.title_id = s.title_id
        LEFT JOIN
    stores AS st ON s.stor_id = st.stor_id
WHERE
    t.title = 'Is Anger the Enemy?';

-- 4. Using RIGHT JOIN: select all the books (and show their titles) that have a link to the employee Howard Snyder.
SELECT 
    t.title, e.fname, e.lname
FROM
    employee e
        RIGHT JOIN
    titles t ON e.pub_id = t.pub_id
WHERE
    e.fname = 'Howard'
        AND e.lname = 'Snyder';

-- 5. Using INNER JOIN: select all the authors that have a link (directly or indirectly) with the employee Howard Snyder
SELECT 
    a.au_lname, a.au_fname, e.fname, e.lname
FROM
    authors a
        INNER JOIN
    titleauthor ta ON a.au_id = ta.au_id
        INNER JOIN
    titles t ON ta.title_id = t.title_id
        INNER JOIN
    publishers p ON t.pub_id = p.pub_id
        INNER JOIN
    employee e ON p.pub_id = e.pub_id
WHERE
    e.fname = 'Howard'
        AND e.lname = 'Snyder';

-- 6. Using the JOIN of your choice: Select the book title with higher number of sales (qty)
SELECT 
    s.title_id, t.title, SUM(s.qty) AS qty
FROM
    sales AS s
        RIGHT JOIN
    titles AS t ON s.title_id = t.title_id
GROUP BY s.title_id , t.title
ORDER BY SUM(s.qty) DESC
LIMIT 1;

/**************************
CASE
**************************/
-- https://www.w3schools.com/sql/sql_case.asp

-- 7. Select everything from the sales table and create a new column called "sales_category" with case conditions to categorise qty
--  * qty >= 50 high sales
--  * 20 <= qty < 50 medium sales
--  * qty < 20 low sales
SELECT 
    *,
    CASE
        WHEN qty >= 50 THEN 'high sales'
        WHEN qty < 20 THEN 'low sales'
        ELSE 'medium sales'
    END AS sales_category
FROM
    sales;

-- 8. Adding to your answer from question 7. Find out the total amount of books sold (qty) in each sales category
-- i.e. How many books had high sales, how many had medium sales, and how many had low sales
SELECT 
    CASE
        WHEN qty >= 50 THEN 'high sales'
        WHEN qty < 20 THEN 'low sales'
        ELSE 'medium sales'
    END AS sales_category,
    SUM(qty)
FROM
    sales
GROUP BY sales_category;

-- 9. Adding to your answer from question 8. Output only those sales categories that have a SUM(qty) greater than 100, and order them in descending order
SELECT 
    CASE
        WHEN qty >= 50 THEN 'high sales'
        WHEN qty < 20 THEN 'low sales'
        ELSE 'medium sales'
    END AS sales_category,
    SUM(qty)
FROM
    sales
GROUP BY sales_category
HAVING SUM(qty) > 100
ORDER BY SUM(qty) DESC;

-- 10. Find out the average book price, per publisher, for the following book types and price categories:
-- book types: business, traditional cook and psychology
-- price categories: <= 5 super low, <= 10 low, <= 15 medium, > 15 high
SELECT 
    pub_id,
    CASE
        WHEN price <= 5 THEN 'super low'
        WHEN price <= 10 THEN 'low'
        WHEN price <= 15 THEN 'medium'
        ELSE 'high'
    END AS price_category,
    AVG(price) AS 'avg_price'
FROM
    titles
WHERE
    type IN ('business' , 'trad_cook', 'psychology')
GROUP BY pub_id , price_category;



USE magist;


SELECT 
    COUNT(*) AS totla_orders
FROM
    orders;

SELECT order_status, COUNT(*) AS total_order
FROM orders
GROUP BY order_status;
SELECT YEAR(order_purchase_timestamp) AS year_,
		MONTH(order_purchase_timestamp) AS month_,
        COUNT(customer_id)
FROM orders
GROUP BY year_, month_
ORDER BY year_, month_;



SELECT COUNT(DISTINCT product_id) AS total_producs
FROM products;

SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS n_products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

SELECT product_category_name,
	COUNT(DISTINCT product_id) AS n_prod
FROM products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

SELECT COUNT(DISTINCT product_id) AS total_order
FROM order_items;
SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;
    
SELECT MAX(price) expensive, MIN(price) Cheapest
FROM order_items;
SELECT 
    MIN(price) AS cheapest, 
    MAX(price) AS most_expensive
FROM 
	order_items;
    
SELECT MAX(payment_value) AS highest_payment, 
		MIN(payment_value) AS lowest_payment
FROM order_payments;

SELECT 
	MAX(payment_value) as highest,
    MIN(payment_value) as lowest
FROM
	order_payments;
-- Business questions
SELECT AVG(price)
FROM order_items;
SELECT product_id , AVG(price)
FROM order_items
GROUP BY product_id
ORDER BY AVG(price) ASC
LIMIT 10;
SELECT product_category_name
FROM products
GROUP BY product_category_name;

SELECT orr.order_id, orr.review_score, oi.price
FROM order_reviews AS orr
INNER JOIN orders oo ON oo.order_id= orr.order_id
INNER JOIN order_items oi ON oi.order_id = orr.order_id
ORDER BY price DESC
LIMIT 10;


SELECT AVG(orr.review_score)
FROM order_reviews AS orr
INNER JOIN orders oo ON oo.order_id= orr.order_id
INNER JOIN order_items oi ON oi.order_id = orr.order_id
ORDER BY price > 2000;







SELECT orr.order_id, orr.review_score, oi.price
FROM order_reviews AS orr
JOIN orders oo ON oo.order_id= orr.order_id
JOIN order_items oi ON oi.order_id = orr.order_id
ORDER BY price DESC
LIMIT 10;


-- In relation to the sellers:


describe orders;
SELECT order_purchase_timestamp
FROM orders
ORDER BY order_purchase_timestamp DESC
LIMIT 1;

SELECT COUNT(product_category_name_english)
FROM product_category_name_translation;

SELECT COUNT(seller_id) AS n_s
FROM sellers;


-- Are expensive tech products popular? *
SELECT 
    CASE
        WHEN price BETWEEN 150 AND 200 THEN 'expensive'
        WHEN price > 200 THEN 'super expensive'
        ELSE 'cheap'
    END AS price_category,
    COUNT(order_items.order_id) AS nr_sold,
    AVG(order_reviews.review_score)
FROM
    orders
        JOIN
    order_items ON orders.order_id = order_items.order_id
        JOIN 
    order_reviews ON order_items.order_id = order_reviews.order_id
        JOIN
    products ON order_items.product_id = products.product_id
        JOIN
    product_category_name_translation AS transl ON products.product_category_name = transl.product_category_name
WHERE
    product_category_name_english IN ("electronics", "computers", "computers_accessories", "audio", "pc_gamer", "consoles_games", "cine_photo")
GROUP BY price_category
ORDER BY nr_sold DESC;

SELECT COUNT( DISTINCT sl.seller_id)  avgslel,  (SUM( DISTINCT sl.seller_id)) /(SELECT COUNT(DISTINCT seller_id) 
FROM sellers)*100
FROM sellers sl
JOIN order_items oi ON oi.seller_id = sl.seller_id
JOIN products pr ON pr.product_id = oi.product_id
JOIN product_category_name_translation pc ON pc.product_category_name = pr.product_category_name
WHERE product_category_name_english IN ("electronics", "computers", "computers_accessories", "audio", "pc_gamer", "consoles_games", "cine_photo");


SELECT 
CASE
    WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) >= 5 THEN "0_5_days"
	WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) >= 10 THEN  "6_10_days"
	WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) >= 20 THEN  "10_20_days"
    WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) >= 30 THEN  "20_30_days"
    ELSE   "more_than_months"
    END AS time_category,
    SUM(order_id)
    FROM orders
    GROUP BY time_category;
    
    SELECT 
CASE
	-- WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) = 0 THEN "0_day"
    WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 10 AND  TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) > 0 THEN "10_days"
     WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 20 THEN "20_days"   
	-- WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 20 THEN  "20_days"
	WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 30 THEN  "30_days"
    WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 60 THEN  "60_days"
    ELSE   ">_2_months"
    END AS delivery_time, COUNT(order_id) AS total_prod
    FROM orders
    WHERE order_status LIKE "delivered%"
    GROUP BY delivery_time
    ORDER BY  COUNT(order_id) DESC;
    
    
        SELECT 
CASE
	-- WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) = 0 THEN "0_day"
    WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 10 AND  TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) > 0 THEN "10_days"
     WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 20 THEN "20_days"   
	-- WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 20 THEN  "20_days"
	-- WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 30 THEN  "30_days"
   --  WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 60 THEN  "60_days"
    ELSE   ">20_months"
    END AS delivery_time, COUNT(order_id) AS total_prod
    FROM orders
   WHERE order_status LIKE "%delivered"
    GROUP BY delivery_time
    
    ORDER BY  COUNT(order_id) DESC;
    


SELECT COUNT(order_id)
FROM orders;    
    
    SELECT 
CASE
	-- WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) = 0 THEN "0_day"
    WHEN TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) <= 10 AND TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) >0 THEN "10_days"
     WHEN TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) <= 20 THEN "20_days"   
	-- WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 20 THEN  "20_days"
	-- WHEN TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) <= 30 THEN  "30_days"
   --  WHEN TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) <= 60 THEN  "60_days"
    ELSE   ">20_days"
    END AS delivery_time, COUNT(o.order_id) AS total_prod
    FROM orders o 
    JOIN order_items AS oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    JOIN product_category_name_translation pcn ON pcn.product_category_name = p.product_category_name
    WHERE product_category_name_english IN ("electronics", "computers", "computers_accessories", "audio", "pc_gamer", "consoles_games", "cine_photo")
    AND order_status LIKE "delivered%"
    GROUP BY delivery_time
    ORDER BY  COUNT(order_id) DESC;
    
    
    
    
SELECT SUM(payment_value)
FROM order_payments;

SELECT COUNT(order_id)
FROM orders;


with main as ( 
    SELECT * FROM orders
    WHERE order_delivered_customer_date AND order_estimated_delivery_date IS NOT NULL
    ),
    d1 as (
    SELECT *, (order_delivered_customer_date - order_estimated_delivery_date)/1000/60/60/24 AS delay FROM main
    )
    
SELECT 
    CASE 
        WHEN delay > 101 THEN "> 100 day Delay"
        WHEN delay > 3 AND delay < 8 THEN "3-7 day delay"
        WHEN delay > 1.5 THEN "1.5 - 3 days delay"
        ELSE "< 1.5 day delay"
    END AS "delay_range", 
    AVG(product_weight_g) AS weight_avg,
    MAX(product_weight_g) AS max_weight,
    MIN(product_weight_g) AS min_weight,
    SUM(product_weight_g) AS sum_weight,
    COUNT(*) AS product_count FROM d1 a
INNER JOIN order_items b
ON a.order_id = b.order_id
INNER JOIN products c
ON b.product_id = c.product_id
WHERE delay > 0
GROUP BY delay_range
ORDER BY weight_avg DESC;




SELECT 
    CASE 
        WHEN delay > 101 THEN "> 100 day Delay"
        WHEN delay > 3 AND delay < 8 THEN "3-7 day delay"
        WHEN delay > 1.5 THEN "1.5 - 3 days delay"
        ELSE "< 1.5 day delay"
    END AS "delay_range", 
    AVG(product_weight_g) AS weight_avg,
    MAX(product_weight_g) AS max_weight,
    MIN(product_weight_g) AS min_weight,
    SUM(product_weight_g) AS sum_weight,
    COUNT(*) AS product_count FROM d1 a
INNER JOIN order_items b
ON a.order_id = b.order_id
INNER JOIN products c
ON b.product_id = c.product_id
WHERE delay > 0
GROUP BY delay_range
ORDER BY weight_avg DESC;



SELECT COUNT(DISTINCT seller_id)
FROm sellers;
/*
SELECT COUNT(sl.seller_id) as ts
FROM sellers sl
JOIN order_items orr ON orr.seller_id = sl.order_id
WHERE sl.order_id IN ("electronics", "computers", "computers_accessories", "audio", "pc_gamer", "consoles_games", "cine_photo");



SELECT SUM(op.payment_value)
FROM sellors sl 
JOIN order_items oi ON oi.seller_id = sl.seller_id
JOIN orders ors ON ors.order_id = oi.order_id
JOIN order_payments op ON op.order_id= ors.order_id
GROUP BY sl.seller_id;
*/


SELECT (ROUND(SUM(payment_value))/3095)*3095
FROM order_payments;
SELECT ROUND(SUM(payment_value)/ (SELECT COUNT(seller_id) FROM sellers)) AS avg_income
FROM order_payments;


SELECT COUNT(seller_id)
FROM sellers;

SELECT (DAY(order_delivered_customer_date) - DAY(order_delivered_carrier_date))
FROM orders
LIMIT 10;
-- In relation to the delivery time:
SELECT order_id, order_delivered_customer_date, order_delivered_carrier_date, TIMESTAMPDIFF(DAY, order_delivered_carrier_date,order_delivered_customer_date) AS place_ord
FROM orders
LIMIT 10;


SELECT order_id, order_delivered_customer_date, order_delivered_carrier_date, AVG(TIMESTAMPDIFF(DAY, order_delivered_carrier_date,order_delivered_customer_date)) AS place_ord
FROM orders
ORDER BY place_ord DESC
LIMIT 10;


SELECT AVG(TIMESTAMPDIFF(DAY, order_delivered_carrier_date,order_delivered_customer_date)) 
FROM orders;


-- lot of delay
SELECT  AVG(TIMESTAMPDIFF(HOUR, order_delivered_carrier_date,order_delivered_customer_date)) 
FROM orders;


SELECT  TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp),MAX(order_purchase_timestamp)) AS n_months
FROM orders;



select 
case
    when o.price > 0 and o.price <= 50 then '1. 0-50'
    when o.price > 50 and o.price <= 100 then '2. 50-100'
    when o.price > 100 and o.price <= 150 then '3. 100-150'
    when o.price > 150 and o.price <= 200 then '4. 150-200'
    when o.price > 200 and o.price <= 1000 then '5. 200-1000'
    -- when o.price > 1000 and o.price <= 4000 then '6. 1000-4000'
    else '6. > 1000'
end as price_category, count(*) as num_products_sold, avg(review_score) as avg_review_score,  
count(distinct p.product_id) as num_products_offered
from product_category_name_translation as pt
join products as p
using (product_category_name)
join order_items as o 
using (product_id)
join order_reviews as ors
using (order_id)
where product_category_name_english
in ("electronics", "computers", "computers_accessories", "audio", "pc_gamer", "consoles_games", "cine_photo")
group by price_category
order by price_category;



