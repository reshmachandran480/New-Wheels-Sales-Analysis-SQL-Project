/*
-----------------------------------------------------------------------------------------------------------------------------------
                                                         Queries
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/
  
/*-- QUESTIONS RELATED TO CUSTOMERS

Q1. What is the distribution of customers across states?
Hint: For each state, count the number of customers.*/

SELECT state, 
COUNT(customer_id) AS customers_count 
FROM customer_t
GROUP BY state
ORDER BY customers_count DESC;

/*
INSIGHT:
- High concentration: California, Texas, Florida, and New York have the most customers.
- Moderate presence: States like Colorado, Ohio, Alabama, and Washington have mid-level customers.
- Low presence: Several states (e.g., Wyoming, Vermont, Maine) have very few customers.
- Overall: Customer distribution is uneven across states, with a few states dominating.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* Q2. What is the average rating in each quarter?
-- Very Bad is 1, Bad is 2, Okay is 3, Good is 4, Very Good is 5.

Hint: Use a common table expression and in that CTE, assign numbers to the different customer ratings. 
      Now average the feedback for each quarter. */

WITH RATINGS AS (
SELECT quarter_number,
CASE 
WHEN customer_feedback = 'Very Bad' THEN '1'
WHEN customer_feedback = 'Bad' THEN '2'
WHEN customer_feedback = 'Okay' THEN '3'
WHEN customer_feedback = 'Good' THEN '4'
WHEN customer_feedback = 'Very Good' THEN '5'
END AS rating_value
FROM order_t
) 
SELECT quarter_number,
ROUND(AVG(rating_value),2) AS average_rating
FROM RATINGS
GROUP BY quarter_number
ORDER BY average_rating DESC;

/*
INSIGHT:
- Quarter_1 (3.55) → Highest satisfaction, customers rated closer to Good.
- Quarter_2 (3.35) → Slight drop but still decent satisfaction.
- Quarter_3 (2.96) → Noticeable decline, slipping below the “Okay” level.
- Quarter_4 (2.40) → Lowest satisfaction, clear customer dissatisfaction.
- Overall → Customer satisfaction steadily declined each quarter, ending the year poorly.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* Q3. Are customers getting more dissatisfied over time?

Hint: Need the percentage of different types of customer feedback in each quarter. Use a common table expression and
	  determine the number of customer feedback in each category as well as the total number of customer feedback in each quarter.
	  Now use that common table expression to find out the percentage of different types of customer feedback in each quarter.
      Eg: (total number of very good feedback/total customer feedback)* 100 gives you the percentage of very good feedback. */

WITH CUST_FEEDBACK AS(
SELECT 
quarter_number,
COUNT(customer_feedback) AS total_customer_feedback,
SUM(CASE WHEN customer_feedback = "Very Good" THEN 1 ELSE 0 END) AS very_good,
SUM(CASE WHEN customer_feedback = "Good" THEN 1 ELSE 0 END) AS good,
SUM(CASE WHEN customer_feedback = "Okay" THEN 1 ELSE 0 END) AS okay,
SUM(CASE WHEN customer_feedback = "Very Bad" THEN 1 ELSE 0 END) AS very_bad,
SUM(CASE WHEN customer_feedback = "Bad" THEN 1 ELSE 0 END) AS bad
FROM order_t
GROUP BY quarter_number
)
SELECT quarter_number,
(very_good/total_customer_feedback)*100 AS perc_very_good,
(good/total_customer_feedback)*100 AS perc_good,
(okay/total_customer_feedback)*100 AS perc_okay,
(bad/total_customer_feedback)*100 AS perc_bad,
(very_bad/total_customer_feedback)*100 AS perc_very_bad
FROM CUST_FEEDBACK
ORDER BY quarter_number;

/*
INSIGHT:
- Quarter_1 → Mostly positive feedback (~59%), low dissatisfaction.
- Quarter_2 → Positives declined, negatives increased (~29%).
- Quarter_3 → Negatives outweighed positives.
- Quarter_4 → Severe dissatisfaction (~60% negative).
- Overall → Customer satisfaction dropped quarter by quarter, showing rising dissatisfaction.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* Q4. Which are the top 5 vehicle makers preferred by the customer.

Hint: For each vehicle make what is the count of the customers.*/

SELECT p.vehicle_maker, 
COUNT(o.customer_id) as customer_count
FROM product_t p
JOIN order_t o ON p.product_id = o.product_id
GROUP BY p.vehicle_maker
ORDER BY customer_count DESC
LIMIT 5;

/*
INSIGHT:
- Chevrolet (83 customers) → Most preferred brand.
- Ford (63 customers) → Strong second choice.
- Toyota (52 customers) → Popular, showing trust in reliability.
- Pontiac & Dodge (50 each) → Almost equally preferred.
- Overall → The market is dominated by American brands (Chevrolet, Ford, Dodge, Pontiac), with Toyota as the only major foreign competitor.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* Q5. What is the most preferred vehicle make in each state?

Hint: Use the window function RANK() to rank based on the count of customers for each state and vehicle maker. 
After ranking, take the vehicle maker whose rank is 1.*/

WITH RANKING AS (
SELECT COUNT(c.customer_id) AS customer_count,
p.vehicle_maker,
c.state,
RANK() OVER(PARTITION BY c.state ORDER BY COUNT(c.customer_id) DESC) AS rnk
FROM product_t p 
JOIN order_t o ON p.product_id = o.product_id
JOIN customer_t c ON o.customer_id = c.customer_id
GROUP BY p.vehicle_maker,c.state
)
SELECT customer_count, vehicle_maker, state FROM RANKING
WHERE rnk = 1
ORDER BY state;

/*
INSIGHT:
- Chevrolet → Appears as the top choice in many states (California, Colorado, District of Columbia, Illinois, Missouri, Ohio, Texas, Washington, etc.), making it the most widely preferred brand across states.
- Ford → Strong competitor, leading in states like Alabama, Michigan, Maryland, Virginia, and sharing top spot in others.
- Toyota → Popular in Florida, Georgia, New York, Oklahoma, Oregon, Pennsylvania, showing strong regional demand.
- Pontiac & Dodge → Frequently show up as top makers in multiple states, indicating niche but loyal customer preference.
- Diversity in smaller states → Many smaller states (e.g., Arkansas, Kansas, Iowa, Wisconsin) show ties across many brands, which means customer preferences are fragmented with no single dominant brand.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/*QUESTIONS RELATED TO REVENUE and ORDERS 

-- Q6. What is the trend of number of orders by quarters?

Hint: Count the number of orders for each quarter.*/

SELECT COUNT(order_id) AS order_count,
quarter_number 
FROM order_t o
GROUP BY quarter_number
ORDER BY quarter_number;

/* 
INSIGHT:
- Quarter_1 → 310 orders (highest, strong start to the year).
- Quarter_2 → 262 orders (decline begins).
- Quarter_3 → 229 orders (further drop).
- Quarter_4 → 199 orders (lowest, steady downward trend).
- Overall → Orders consistently decreased quarter by quarter, showing weakening customer demand or engagement over time.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* Q7. What is the quarter over quarter % change in revenue? 

Hint: Quarter over Quarter percentage change in revenue means what is the change in revenue from the subsequent quarter to the previous quarter in percentage.
      To calculate you need to use the common table expression to find out the sum of revenue for each quarter.
      Then use that CTE along with the LAG function to calculate the QoQ percentage change in revenue.
*/
  
WITH QoQ AS(
SELECT
quarter_number,
ROUND(SUM(quantity * vehicle_price - (discount/100)*vehicle_price),2) AS total_revenue
FROM order_t
GROUP BY quarter_number
)

SELECT 
quarter_number, 
total_revenue,
LAG(total_revenue) OVER(ORDER BY quarter_number) AS previous_quarter_revenue,
ROUND(
(total_revenue - LAG(total_revenue) OVER(ORDER BY quarter_number)) /
LAG(total_revenue) OVER(ORDER BY quarter_number)*100,2
) AS QoQ_percentage_charge
FROM QoQ
ORDER BY quarter_number;

/*
INSIGHT:
- Quarter_1 → $39.49M → Baseline quarter (no previous data).
- Quarter_2 → $32.78M (-16.99%) → Significant revenue drop.
- Quarter_3 → $29.30M (-10.63%) → Continued decline, though smaller than Quarter_2.
- Quarter_4 → $23.40M (-20.14%) → Steepest drop of the year.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* Q8. What is the trend of revenue and orders by quarters?

Hint: Find out the sum of revenue and count the number of orders for each quarter.*/

SELECT SUM(quantity * vehicle_price) AS sum_of_revenue,
COUNT(order_id) AS order_count,
quarter_number
FROM order_t
GROUP BY quarter_number
ORDER BY quarter_number;

/*
INSIGHT:
- Quarter_1 → 310 orders | $39.49M revenue → Peak quarter.
- Quarter_2 → 262 orders | $32.78M revenue → Decline in both orders and revenue.
- Quarter_3 → 229 orders | $29.30M revenue → Continued downward trend.
- Quarter_4 → 199 orders | $23.40M revenue → Lowest orders and revenue.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* QUESTIONS RELATED TO SHIPPING 
Q9. What is the average discount offered for different types of credit cards?

Hint: Find out the average of discount for each credit card type.*/

SELECT 
c.credit_card_type,
ROUND(AVG(o.discount),2) AS average_discount
FROM customer_t c
JOIN order_t o ON c.customer_id = o.customer_id
GROUP BY c.credit_card_type 
ORDER BY c.credit_card_type;

/*
INSIGHT:
- Laser (0.64) & Mastercard (0.63) → Highest average discounts.
- Diners Club International (0.58) → Lowest average discount.
- All other cards (Visa, American Express, JCB, Maestro, etc.) → Cluster around 0.60–0.62.
*/

-- ---------------------------------------------------------------------------------------------------------------------------------

/* Q10. What is the average time taken to ship the placed orders for each quarters?

   Hint: Use the datediff function to find the difference between the ship date and the order date.
*/
SELECT quarter_number,
ROUND(AVG(datediff(ship_date,order_date)),2) AS "average_shipment_time(days)"
FROM order_t
GROUP BY quarter_number
ORDER BY quarter_number;

/*
INSIGHT:
- Quarter_1 → 57.2 days → Fastest shipping, reasonable delivery times.
- Quarter_2 → 71.1 days → Shipping delays increased.
- Quarter_3 → 117.8 days → Major jump in delays, almost double Quarter_1’s time.
- Quarter_4 → 174.1 days → Extremely delayed, nearly 3× longer than Quarter_1.
*/

-- --------------------------------------------------------Done----------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------