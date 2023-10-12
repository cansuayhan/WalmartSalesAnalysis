CREATE DATABASE IF NOT EXISTS PortfolioProject;

create database if not exists WalmartSales;

create table if not exists sales (
invoice_id VARCHAR(30) not null primary key,
branch varchar(30) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(50) not null,
unit_price decimal(5,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(10,2) not null,
date datetime not null,
time time not null,
Payment varchar(30) not null,
cogs decimal(10,2) not null,
gross_margin_pctg float(11,9) not null,
gross_income decimal(12,4) not null,
rating float(2,1) not null
);



-- ----------------------- Feature Engineering--------------

-- time_of_day

Select time, 
(Case 
    When 'time' between "00:00:00" and "12:00:00" Then "Morning"
    When 'time' between "12:00:00" and "16:00:00" Then "Afternoon"
    else "Evening"
    END
) as time_of_date
from sales;

ALTER table sales ADD Column time_of_date VARCHAR(20);

Select *
From sales;

update sales 
set time_of_date = 
(Case 
    When time between "00:00:00" and "12:00:00" Then "Morning"
    When time between "12:00:00" and "16:00:00" Then "Afternoon"
    else "Evening"
END
);

Select *
From sales;


-- day_name 

Select date, dayname(date) as day_name
from sales;


alter table sales add column day_name VARCHAR(20);

update sales 
set day_name = dayname(date);

select date, day_name
from sales;


-- month name


alter table sales add column month_name varchar(20);

select * 
from sales;


select date, monthname(date) as month_name
from sales;

update sales 
set month_name = monthname(date);

-- -----------------------------------------------


-- Generic Questions ---

-- How many unique cities does the data have?

Select count(distinct city)
from sales;

select distinct city
from sales;

-- In which city is each branch?

select *
from sales;

select distinct city, branch
from sales
order by branch;

-- -------- PRODUCT ----------

-- How many unique product lines does the data have?

select *
from sales;

select distinct product_line
from sales;

select count(distinct product_line)
from sales;

-- What is the most common payment method?

select MAX(payment), count(payment) as count
from sales 
group by payment
order by count desc
limit 1
;

-- What is the most selling product line?-

select product_line, sum(quantity) as qtty
from sales
group by product_line
order by qtty desc
;


-- What is the total revenue by month? 

select *
from sales;

select month_name , sum(gross_income) as revenue
from sales
group by month_name
order by revenue desc;

--  What month had the largest COGS?

select *
from sales;

select month_name , sum(cogs) as total_cogs
from sales
group by month_name
order by total_cogs desc;

-- What product line had the largest revenue?

select *
from sales;


select product_line, sum(gross_income) as productline_revenue
from sales
group by product_line
order by productline_revenue desc;

-- What is the city with the largest revenue?


select *
from sales;

select city, sum(gross_income) as city_revenue
from sales
group by city
order by city_revenue desc
;


-- What product line had the largest VAT?

select *
from sales;


select product_line, sum(VAT) as total_vat
from sales
group by product_line
order by total_vat desc;


-- Fetch each product line and add a column to those product line showing
--  "Good", "Bad". Good if its greater than average sales

select avg(quantity) as avg_quantity
from sales;

select 
product_line,
(case 
  when avg(quantity) < 6 then "BAD"
  else "good"
  end 
)
from sales
group by product_line;

-- Which branch sold more products than average product sold?

select * 
from sales;


select branch, sum(quantity), avg(quantity)
from sales
group by branch
order by sum(quantity) desc;

-- or 

select branch, sum(quantity)
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?

select *
from sales;

select gender, product_line, count(product_line) as most_common
from sales
group by gender, product_line
order by most_common desc;

-- What is the average rating of each product line?

select * 
from sales;

select product_line, avg(rating) as avg_rating
from sales
group by product_line
order by avg_rating;

-- or 

SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- ---------- CUSTOMER -----------

-- How many unique customer types does the data have?

select *
from sales;

select distinct customer_type
from sales;

select count(distinct customer_type)
from sales;

-- How many unique payment methods does the data have?

select * 
from sales;

select distinct payment
from sales;

select count(distinct payment)
from sales;

-- What is the most common customer type?

select *
from sales;

select customer_type, count(customer_type) as c_type
from sales
group by customer_type
order by c_type desc;


-- Which customer type buys the most?

select *
from sales;

select customer_type, sum(quantity) as type_bys
from sales
group by customer_type
order by type_bys desc;

-- What is the gender of most of the customers?

select *
from sales;

select gender, count(gender) as gndr
from sales
group by gender
order by gndr desc;


-- What is the gender distribution per branch?

select * 
from sales;

select branch, gender, count(gender) as distr
from sales
group by branch, gender
order by branch asc;


-- Which time of the day do customers give most ratings?

select *
from sales;


select time_of_date, avg(rating) as mst_rating
from sales
group by time_of_date 
order by mst_rating desc;

-- Which time of the day do customers give most ratings per branch?

select *
from sales;

select branch, time_of_date, avg(rating) avg_per_branch
from sales
group by branch, time_of_date
order by branch, avg_per_branch desc;

-- Which day fo the week has the best avg ratings?

select * 
from sales;


select day_name, avg(rating) as day_rating
from sales
group by day_name
order by day_rating desc;

-- Which day of the week has the best average ratings per branch?

select *
from sales;

select branch, day_name, avg(rating) as brnch_day_rating
from sales
group by branch, day_name
order by branch, brnch_day_rating desc;

-- ---------------- SALES -------------

-- Number of sales made in each time of the day per weekday

select *
from sales;


select day_name, time_of_date, count(quantity) as qtty
from sales
where day_name <> "Sunday"
group by day_name, time_of_date 
order by day_name, qtty desc;


-- Which of the customer types brings the most revenue?

select *
from sales;

select customer_type, sum(gross_income) as mst_revenue
from sales
group by customer_type
order by mst_revenue desc;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select * 
from sales;

select city, avg(vat) as avg_vat
from sales
group by city
order by avg_vat desc;

select city, vat
from sales
order by vat desc;


-- Which customer type pays the most in VAT?

select * 
from sales;

select customer_type, avg(vat) as cst_avg_vat
from sales
group by customer_type
order by cst_avg_vat desc;

