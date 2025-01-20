
/*Top 10 customer by revenue, their business name, countries
*/

with Revdetail as
(
Select *, UnitPrice*Quantity*(1-Discount) as Revenue
from [Northwind].[Order Details] 
)
	select *
	from
	(
		select cus.CustomerID, cus.CompanyName, cus.Country, round(sum (rev.Revenue),0) as CusRevenue,
		RANK () over (order by round(sum (rev.Revenue),0) desc) as Rev_Rank
		from Revdetail as Rev
		join [Northwind].[Orders] as o
		on rev.OrderID = o.OrderID
		join [Northwind].[Customers] as Cus
		on cus.CustomerID = o.CustomerID
		group by cus.CustomerID, cus.CompanyName, cus.Country
	) q1
	where q1.Rev_Rank < 11

/*Top 10 products, Show their names? category? supplier?
*/

with Product_rank as
(
select *
from (
	select ProductID, round(sum(UnitPrice*Quantity*(1-Discount)),0) as PRevenue,
	rank () over (order by sum(UnitPrice*Quantity*(1-Discount)) desc) as Product_rank
	from [Northwind].[Order Details]
	group by ProductID
	) q1
where q1.Product_rank < 11
)
select Prank.ProductID, Prank.PRevenue,Prank.Product_rank, pro.ProductName, ca.CategoryName, sus.CompanyName as SupplierName
from Product_rank  as prank
join [Northwind].[Products] as pro
on prank.ProductID = pro.ProductID
join [Northwind].[Categories] as ca
on ca.CategoryID = pro.CategoryID
join [Northwind].[Suppliers] as Sus
on Sus.SupplierID = pro.SupplierID

/*Revenue by years/months
*/
Select 
OrderYear,
OrderMonth, 
sum(Order_Revenue) as Sum_Revenue
From (
	select o.OrderID,
	cast(OrderDate as date) as OrderDate2, 
	Year(o.OrderDate) as OrderYear,
	Month(o.OrderDate) as OrderMonth, q1.Order_Revenue
	from (
		select OrderID,
		round(sum(UnitPrice*Quantity*(1-Discount)),0) as Order_Revenue
		from [Northwind].[Order Details]
		group by OrderID
		)q1
		join [Northwind].[Orders] as o
		on q1.OrderID = o.OrderID
		) q2
group by OrderYear, OrderMonth
Order by OrderYear, OrderMonth

/*Question: Top 10 customers and the top 10 products they have spent the most on: Show Customer ID, 
customer rank by revenue, ProductID, Product revenue & ranking (for each customer)  
*/
 With ProductRank as
(
select *
 from (
	select ProductID, o.customerID, round(sum(UnitPrice*Quantity*(1-Discount)),0) as PRevenue,
	rank () over (partition by o.customerID order by sum(UnitPrice*Quantity*(1-Discount)) desc) as Product_rank
	from [Northwind].[Order Details] as od
	join [Northwind].[Orders] as o
	on od.orderID = o.orderID
	Group by ProductID, o.customerID
	) q1
where Product_rank < 11 
)
, CustomerRank as
(
 select *
 from (
	select o.CustomerID, round(sum(UnitPrice*Quantity*(1-Discount)),0) as Customer_Revenue,
	rank () over (order by round(sum(UnitPrice*Quantity*(1-Discount)),0) desc) as Rank_customer
	From [Northwind].[Order Details] as od
	join [Northwind].[Orders] as o
	on od.OrderID = o.OrderID
	Group by o.CustomerID
	) q2
 where rank_customer < 11
)
select  pr.customerID, Rank_customer, ProductID, Product_rank, PRevenue
From ProductRank as pr
join CustomerRank as cr
on pr.customerID = cr.customerID
Order by Rank_customer

/*Top 5 countries and their revenue
*/

with Revdetail as
(
Select OrderID, UnitPrice*Quantity*(1-Discount) as Revenue
from [Northwind].[Order Details] 
)
select *
from (
	select distinct cu.country, 
	cast(sum(re.Revenue) as int) as Country_Revenue,
	rank () over (order by sum(re.revenue) desc) as rank_country
	From Revdetail as re
	Join [Northwind].[Orders] as od
	on re.OrderID = od.OrderID
	join [Northwind].[Customers] as cu
	on od.CustomerID = cu.CustomerID
	group by cu.country
	) q1
where rank_country < 6

/*Avg order value of all countries and of top 5 countries
*/
with OrderRevenue as
(
select orderID, sum(UnitPrice*Quantity*(1-Discount)) as Order_Revenue
From [Northwind].[Order Details]
Group by OrderID
)
select *
from 
	(
	Select country, cast(avg(order_revenue) as int) as Avg_Country, cast(avg(Avg_Order) as int) as Avg_All
	From 
		(
		select orr.OrderID, cu.country, Orr.Order_Revenue, Avg(Orr.Order_Revenue) over () as Avg_Order
		From OrderRevenue orr
		join [Northwind].[Orders] o
		on orr.OrderID = o.OrderID
		join [Northwind].[Customers] cu
		on o.CustomerID = cu.CustomerID
		) q1
	Group by country
	) q2
where q2.country in
	(
	select country
	from (
		select distinct cu.country, 
		cast(sum(orr.Order_Revenue) as int) as Country_Revenue,
		rank () over (order by sum(orr.Order_Revenue) desc) as rank_country
		From OrderRevenue as orr
		Join [Northwind].[Orders] as od
		on orr.OrderID = od.OrderID
		join [Northwind].[Customers] as cu
		on od.CustomerID = cu.CustomerID
		group by cu.country
		) q1
	where rank_country < 6
	)
order by avg_country desc


/* Customer grouping? Big customers: total revenue above 25k, Medium: 10k - 25k, Small < 10k. % of each group
*/

Select Customer_Group, G_Revenue, count_customer, round(G_revenue/Total_Revenue,2) as Revenue_Percentage,
round(count_customer/Total_Customer,2)as Customer_Percentage
From
(
Select distinct Customer_Group, cast(sum(Customer_Revenue) over(partition by Customer_Group) as float) as G_revenue, 
cast(count (Customer_group) over(partition by customer_Group) as float) as count_customer,
cast(sum (Customer_Revenue) over() as float) as Total_Revenue,
cast(count(Customer_Group) over () as float) as Total_Customer
from 
	(
	select  orr.CustomerID,cast(sum(UnitPrice*Quantity*(1-Discount)) as int) as Customer_Revenue,
	case when sum(UnitPrice*Quantity*(1-Discount)) > 25000 then 'Big'
	When sum(UnitPrice*Quantity*(1-Discount)) < 10000 then 'Small'
	else 'Medium'
	end as Customer_group
	From [Northwind].[Order Details] od
	join [Northwind].[Orders] orr
	on od.OrderID = orr.OrderID
	Group by orr.CustomerID
	) q1
) q2
		

/*Question: How often did the customers order?
*/
select avg(Avg_OrderDay) as Avg_All
from 
(
	select customerID, avg(daydiff) as Avg_OrderDay
	from
		(
		select OrderID, CustomerID,OrderDate,
		lead(orderdate) over (partition by customerID order by o.OrderDate) as nextorderdate,
		datediff(day, OrderDate,lead(orderdate) over (partition by customerID order by o.OrderDate)) as daydiff
		from [Northwind].[Orders] o
		) q1
	where nextorderdate is not null
	Group by customerID
) q1

/*Question: How often did the customers in different group order?
*/
with CustomerGroup as 
(
select  orr.CustomerID,cast(sum(UnitPrice*Quantity*(1-Discount)) as int) as Customer_Revenue,
	case when sum(UnitPrice*Quantity*(1-Discount)) > 25000 then 'Big'
	When sum(UnitPrice*Quantity*(1-Discount)) < 10000 then 'Small'
	else 'Medium'
	end as Customer_group
	From [Northwind].[Order Details] od
	join [Northwind].[Orders] orr
	on od.OrderID = orr.OrderID
	Group by orr.CustomerID
)
, OrderDay as
(
select customerID, avg(daydiff) as Avg_OrderDay
	from
		(
		select OrderID, CustomerID,OrderDate,
		lead(orderdate) over (partition by customerID order by o.OrderDate) as nextorderdate,
		datediff(day, OrderDate,lead(orderdate) over (partition by customerID order by o.OrderDate)) as daydiff
		from [Northwind].[Orders] o
		) q1
	where nextorderdate is not null
	Group by customerID
)
select Customer_Group, avg(Avg_OrderDay) as Avg_OrderDay_G
From CustomerGroup as cg
join OrderDay as odd
on cg.customerID = odd.customerID
group by Customer_Group
