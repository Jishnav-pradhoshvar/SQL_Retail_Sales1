-- Sales Retail Analysis
create database project2;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

select * from retail_sales
limit 5;

delete from retail_sales
where age is null 
or category is null 
or quantity is null 
or price_per_unit is null 
or cogs is null 
or total_sale is null ;

-- Data Exploration :

-- Sales 
select count(*) as Total_sales from retail_sales;

-- Customers 
select count(distinct customer_id) as Total_sales from retail_sales;

-- category
select distinct category as Category from retail_sales;


-- Data Analysis 

-- 1.Write a SQL query to retrieve all columns for sales made on 2022-11-05:

select * from retail_sales 
where sale_date = '2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

select * from retail_sales
where category = 'Clothing' and 
TO_CHAR (sale_date,'YYYY-MM') = '2022-11' and 
quantity >= 4 ;

--3.Write a SQL query to calculate the total sales (total_sale) for each category :

select category , sum(total_sale) from retail_sales
group by 1 ;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select category , avg(age) from retail_sales
where category = 'Beauty'
group by category ;

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale > 1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category. :

select category,gender,count(*) as Total_Transcation from retail_sales
group by category,gender 
order by 1;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year :

select
EXTRACT(YEAR FROM sale_date) as Year , 
EXTRACT(MONTH FROM sale_date) as Month,
max(AVG(total_sale)) as Avg_sales from retail_sales
group by 1,2
order by 1,3 desc;

select year,month,Avg_sales from (
select 
extract(YEAR FROM sale_date) as year,
extract(MONTH FROM sale_date) as month ,
avg(total_sale) as Avg_sales,
rank() over(partition by Extract(YEAR FROM sale_date)
order by avg(total_sale) Desc ) as rank from retail_sales 
group by 1,2
) as T1
where rank = 1;

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales:

select customer_id, sum(total_sale) as total_sale
from retail_sales
group by 1
order by total_sale desc
limit 5

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.:

select category,count(distinct customer_id)
from retail_sales 
group by 1


-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sale   -- used Common Table Expression (CTE) to group by
as 
(select 
sale_time as time ,
case
when extract(Hour from sale_time) < 12 then 'Morning'
when extract(Hour from sale_time) > 12 and extract(Hour from sale_time) < 17 then 'Afternoon'
when extract(Hour from sale_time) > 17 and extract(Hour from sale_time) < 21 then 'Evening'
else 'Night'
end as shift
from retail_sales )
select shift , count(*)
from hourly_sale
group by shift



