## New-Wheels-Sales-Analysis-SQL-Project

### 1. Introduction
This project provides a comprehensive analysis of the "New Wheels" vehicle company's performance over a year. Using a MySQL database, this analysis explores key business areas, including customer distribution, product preferences, and operational efficiency. The primary goal is to uncover data-driven insights that reveal critical trends in sales, customer satisfaction, and logistics, and to provide actionable recommendations to address the challenges identified.

### 2. Dataset
The analysis is based on a MySQL dump file named **`new_wheels_dumpfile.sql`**. The database (**`vehdb`**) contains four main tables:
- **`customer_t`**: Stores detailed information about each customer, including demographics, location, and contact details.
- **`product_t`**: Contains information about the vehicle products, such as make, model, year, and price.
- **`shipper_t`**: Holds details about the shipping companies used for deliveries.
- **`order_t`**: Records all transaction details, including customer and product IDs, order dates, shipping information, and customer feedback

#### Database Schema (ERD)
<img width="916" height="756" alt="Image" src="https://github.com/user-attachments/assets/8abda645-58ee-4641-952f-a1952abd1f53" />

### 3. Tools Used
- **Database**: MySQL
- **Language**: SQL for data querying and aggregation.

### 4. Analysis and Insights
The analysis was guided by a series of questions aimed at understanding different facets of the business.

#### Q1. Distribution of customers across states
- **Query:** Count customers per state.
- **Insight:**
    - California & Texas lead (97 each).
    - Florida & New York follow.
    - Many states have very few customers → customer base is **unevenly distributed**.

#### Q2. Average rating in each quarter
- **Query:** Map feedback (1–5) and find average per quarter.
- **Output:**
     - Quarter_1: 3.55
     - Quarter_2: 3.35
     - Quarter_3: 2.96
     - Quarter_4: 2.40
- **Insight:**
     - Ratings declined steadily each quarter, worst in Quarter_4.
 
#### Q3. Are customers getting more dissatisfied over time?
- **Query:** Find percentage of feedback types per quarter.
- **Insight:**
     - Quarter_1: ~59% positive → Quarter_4: only 20% positive.
     - Negative feedback rose to **~60% in Quarter_4**.
     - Clear trend of **increasing dissatisfaction**.

#### Q4. Top 5 vehicle makers preferred by customers
- **Output:**
       1. Chevrolet (83)
       2. Ford (63)
       3. Toyota (52)
       4. Pontiac (50)
       5. Dodge (50)
- **Insight:**
      - U.S. brands dominate, with Toyota as the only foreign competitor.

#### Q5. Most preferred vehicle make in each state
- **Query:** Used **`RANK()`** by state and maker.
- **Insight:**
    - **Chevrolet** most popular across many states.
    - **Ford & Toyota** also strong in multiple regions.
    - Smaller states show **fragmented preferences**.

#### Q6. Trend of orders by quarter
- **Output:**
     - Quarter_1: 310 → Quarter_4: 199
- **Insight:**
     - Orders **consistently decreased each quarter**, lowest in Quarter_4.

#### Q7. Quarter-over-quarter % change in revenue
- **Output:**
    - Quarter_2: -16.99%
    - Quarter_3: -10.63%
    - Quarter_4: -20.14%
- **Insight:**
     - Revenue dropped every quarter, steepest in **Quarter_4 (-20%)**.

#### Q8. Trend of revenue and orders by quarter
- **Output:**
     - Both revenue and orders **declined together** each quarter.
- **Insight:**
     - Indicates **weakening demand & sales performance**.

#### Q9. Average discount offered by credit card type
- **Output Range:** 0.58 – 0.64
-  **Insight:**
      - Discounts are **fairly uniform** across card types.
      - Laser (0.64) & Mastercard (0.63) slightly higher.

#### Q10. Average shipping time per quarter
- **Output:**
    - Quarter_1: 57 days → Quarter_4: 174 days
- **Insight:**
    - Shipping delays **worsened drastically** each quarter.
    - Likely a key driver of falling ratings & customer dissatisfaction.
 
### 5. Key Findings and Recommendations

#### Summary of Findings
The data tells a clear and urgent story: "New Wheels" starts the year on a strong footing but suffers a severe decline in performance as the year progresses. This is not just a minor dip but a systemic failure across key business metrics. The core issue is a catastrophic increase in order fulfillment times, which has a direct negative impact on customer satisfaction, leading to a significant drop in both sales and revenue.

#### Actionable Recommendations
1. **Investigate and Overhaul the Supply Chain:** The escalating shipping delay is the most critical issue. An urgent, top-to-bottom review of the logistics and supply chain is necessary to identify and resolve the bottlenecks causing these delays, especially in the second half of the year.
2. **Focus on Customer Retention:** The sharp decline in customer satisfaction requires immediate action. The company should proactively communicate with customers experiencing delays, offer incentives, and improve customer service to mitigate the damage to its reputation.
3. **Re-evaluate Quarter_4 Strategy:** The final quarter is the weakest for both sales and customer satisfaction. The company must analyze why performance deteriorates during this period—whether due to inventory issues, staffing shortages, or shipping partner failures—and develop a robust plan to handle demand effectively.
4. **Leverage Regional Strengths:** While addressing operational issues, marketing efforts should continue to focus on the high-performing states (CA, TX, FL, NY) where the brand has a strong presence. Tailored regional campaigns could help maintain market share while broader issues are being resolved.

### 6. How to Use This Repository
1. **Set up the Database:**
- Create a new database in your MySQL instance (e.g., **`vehdb`**).
- Import the schema and data using the provided **`new_wheels_dumpfile.sql`** file.

```
mysql -u reshmachandran480 -p vehdb < new_wheels_dumpfile.sql
```      

2. **Run the Analysis:**
- The SQL queries used for this analysis are included in this README.
-  You can run them in any SQL client connected to your database to replicate the findings.

### 7. Project Structure
```
New-Wheels-Sales-Analysis-SQL-Project/
|
|---- README.md
|
|---- documentation/
|     |---- new_wheels_erd.md  
|
|---- sql_scripts/
      |---- 01_database_setup.sql
      |---- 02_analysis_queries.sql
```

#### Author
* **Reshma Chandran R**
* [LinkedIn Profile](https://www.linkedin.com/in/reshma-chandran-r-586877198/)
* [GitHub Profile](https://github.com/reshmachandran480)

