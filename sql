-- For each product in the database, calculate how many more orders where placed in 
-- each month compared to the previous month.

-- IMPORTANT! This is going to be a 2-day warmup! FOR NOW, assume that each product
-- has sales every month. Do the calculations so that you're comparing to the previous 
-- month where there were sales.
-- For example, product_id #1 has no sales for October 1996. So compare November 1996
-- to September 1996 (the previous month where there were sales):
-- So if there were 27 units sold in November and 20 in September, the resulting 
-- difference should be 27-7 = 7.
-- (Later on we will work towards filling in the missing months.)

-- BIG HINT: Look at the expected results, how do you convert the dates to the 
-- correct format (year and month)?


WITH product_info AS (SELECT products.product_id, extract(year from orders.order_date) as year, extract(month from orders.order_date) as month,
					  sum(order_details.quantity) AS units_sold
FROM orders INNER JOIN order_details ON orders.order_id = order_details.order_id 
INNER JOIN products ON products.product_id = order_details.product_id
group by products.product_id, orders.order_date
order by products.product_id),

lag_info AS (SELECT *, lag(units_sold, 1) over (partition by product_id)
previous_month, units_sold - lag(units_sold, 1) over (partition by product_id) difference from product_info),

results AS (SELECT product_id, year, month, units_sold, previous_month, coalesce(difference,0) AS difference FROM lag_info)


SELECT * from results;