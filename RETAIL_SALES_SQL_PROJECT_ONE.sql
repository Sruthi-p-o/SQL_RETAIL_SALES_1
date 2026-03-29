--*DATA CLEANING*---

--Create Table
Create Table retail_Sales(
transactions_id	int PRIMARY KEY,
sale_date date,
sale_time time,
customer_id INT,
gender varchar(10),
age int,
category varchar(100),
quantiy int,
price_per_unit float,
cogs float,
total_sale float)

--Retrive data
Select * from retail_sales ;

--Retrive Data first 10 rows
Select * from retail_sales limit 10;

--Count the rows
select count(*) from retail_sales;

--where transcation id is null
select * from retail_sales where transactions_id is null;

--where sale_date id is null
select * from retail_sales where sale_date is null;

--where sale time is null
select * from retail_sales where sale_time is null;

--all in one query
select * from retail_sales where 
transactions_id is null
or sale_date is null 
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_Sale is null;

--Delete null rows
Delete from retail_sales where 
transactions_id is null
or sale_date is null 
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_Sale is null;

--*Data exploration*--Business Problems
--1.How many sales we have?
select count(*) as total_sales from retail_sales;

--2.How many customers we have
select count(distinct(customer_id)) as total_customer from retail_Sales;

--3.How many category name
select distinct(category) as category from retail_sales;

--*DATA ANALYSIS AND BUSINESS PROBLEMS*--

--1.Write an SQL query to calculate the total sales for sales on '2022-11-05'
select * from retail_sales where sale_date='2022-11-05';

--2.Write a sql query to retrive al transcatins where category is clothing and quantity sold is more than
--10 in a month of Nov-2022
select * from retail_sales where category='Clothing'
and quantiy>=4 and to_CHAR(sale_date,'YYYY-MM')='2022-11'

--3.Write sql query to calculate the total sales (total_sale) for each category
Select category,sum(total_Sale) as net_sales,count(*) as orders from retail_sales group by category;

--4.Write sql query to find average age of customers who purchased items from the 'Beauty' category
select AVG(age) as avg_age from retail_sales where category='Beauty'

--5.Write a sql query to find all transcations where total_Sale is greater than 1000.
select * from retail_sales where total_sale>1000;

--6.Write a sql query to find total number of transcations made by each gender by each category
select gender,category,count(*) as total_trans from retail_sales group by category,gender

--7.Write the sql query to calcuate the averge sale for each month  find out best selling month in each year
select * from
(
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_Sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc) as rank
from retail_sales
group by 1,2) as t1
where rank=1

--8.Write the sql query to find top 5 customers based on  highest total_sales
select customer_id,sum(total_Sale) as total_Sales from retail_Sales
group by 1 order by 2 desc limit 5;

--9.Write the sql query to find number of unique customers who purchased from each category
select count(distinct(customer_id)),category from retail_sales group by category;

--10.Write the sql query to find to create each shift and number of orders Example morning<=12,afternoon 12 and 17, evening>17
with hourly_sales
as (
select *,case 
when extract(hour from sale_time)<12 then 'Morning'
when extract(hour from sale_time)between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales
)
select shift,count(transactions_id) as total_orders from hourly_sales group by shift;