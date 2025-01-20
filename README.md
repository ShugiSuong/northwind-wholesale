# Northwind-Wholesale Profit Improvement
Sales performance analytics to drive profit improvement and strengthen customer relationships.
# Background and overview
Northwind is a wholesale distributor that supplies a wide range of food and beverage products to retail businesses, restaurants, and other companies worldwide.
The company operates through a digital platform where customers can browse products, place orders, and manage their accounts.
Northwind's objective is to increase its profit while providing quality products and maintaining strong relationships with its customers
# Dataset and structure
The dataset consists of 12 tables with the relationship illustrated below:
<img width="615" alt="tablesdiagram" src="https://github.com/user-attachments/assets/cdfff41b-a690-41ae-9406-dc8284698498" />
# Objective
Present key findings and recommendations that can benefit the company to increase its profit effectively & sustainably 
3 areas to investigate: Sales performance, Customer analysis, and Product analysis
# Research questions
## General sale performance
1. What are the sales & profit performance over time? What is the trend, is it increasing or decreasing
2. What category generates the most sales and profit? The trend over time?
3. What is the relationship between profit and sales and discounts? Negative or positive? 
4. What are the top countries by revenue/profit
## Customer analysis
1. Who are the biggest customers? What is their revenue contribution? How many orders did they make? How often did they order? How many products are in one order?
2. What is the number of customers who order overtime? Relationship with total revenue and profit in the same period?
3. Is getting discounts encouraging customers to order higher quantities?
4. Is increasing or decreasing the product price over time affecting the order quantity of the same product?
## Product analysis 
1. Which products generate the highest revenue/ profit?
2. Which gets the highest order quantity?
3. Quadrant analysis by profit and quantity to determine 4 groups of products to consider strategic decisions: Group 1: high profit, high quantity; Group 2: High profit, low quantity; Group 3: Low profit, high quantity; Group 4: low profit, low quantity
4. What are the price ranges of the products? Which range gets the most orders? Highest revenue?
5. Units in stock vs average order quantity to avoid order loss due to stock unavailability
# Data Exploration with SQL
Check out the SQL queries [here] (https://github.com/ShugiSuong/northwind-wholesale/blob/main/SQLqueries.sql)
# Data Visualization with Tableau
Check out the Dashboard [here](https://public.tableau.com/app/profile/suong.hoang/viz/NorthwindProject_17313234121030/SaleDashboard?publish=yes)
<img width="702" alt="screenshot sale performance" src="https://github.com/user-attachments/assets/82e50533-25a3-4f21-8a92-dc776cd7f725" />
# Finding
1.	50% of total revenue is generated from a 13% customer base: A small segment of customers is responsible for a substantial portion of our income
2. One of our key customers (ID: MEREP) has abruptly ceased placing orders.
3.	50% of total orders are less than 1k but accounted for only 16% of revenue. Large orders above 3k : 11% orders accounted for 40% of the revenue
4. 3 out of the top 10 products were decided not to continue which will have a significant negative impact on revenue as well as relationships with customers who have a high purchased volume of them
5.	 Customers who have more numbers of products tend to buy more in total
6. Top customers are most interested in the top products. 
7. Many products have stock levels lower than the minimum quantity required: causing potential loss of sale due to understock, especially for the top-selling. At the same time, many are overstocked, causing storage costs, loss due to expired stock, and cash flow issues…
8. The current reorder point (ROP) set by the company is not a good indicator of managing stock level: too high, too low, at 0
9. 9 of of 10 top products (check next slide) with ROP at 0 (meaning only reorder when they are run out of stock): very risky
# Recommendations
## Immediate actions to implement
1.	Restock best-selling items currently out of stock or low in inventory to avoid sales loss
2.	Reactivate key product IDs 29, 17, and 28, previously in the top 10, to the product lineup.
3.	Investigate why MEREP ceased orders and restore the relationship
4.	Examine customers previously ranked #6 to #10 to identify reasons for their decreased rankings.
5.	Update Inventory Strategies: Establish a new reorder point (ROP) system for improved inventory management.
6.	Clear Overstock: Launch a stock clearance promotion to manage overstocked items efficiently.
 
## Strategic recommendation
1.	Focusing intensively on the top customers  with loyalty programs, contracting, personalized account manager
2.	At the same time engaging and developing relationships with the remaining customers to encourage them to order more 
3.	Separating shipping cost from product pricing to make them appear more competitive and to be more flexible with the different offerings to different customers/products
4.	Offering free shipping with the condition of Minimum order value to encourage larger order
5.	Introducing a minimum order threshold of 200$ gradually and flexibly to different groups of customers
6.	Regularly communicate with customers through newsletters or updates on new products and offers to keep them engaged
7.	Expanding market, acquiring new customers
# Detail Presentation
Please check out the detail presentation [here](https://docs.google.com/presentation/d/1-WhO7SXwPu-0jhNwwcNKFUJAKjC0-ZT4/edit?usp=sharing&ouid=114710215277295122728&rtpof=true&sd=true)
