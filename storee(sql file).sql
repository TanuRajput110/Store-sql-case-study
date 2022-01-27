SELECT count(*) FROM tanu.storee;
/* First dataset look */
SELECT * FROM tanu.storee;

-- DATASET  INFORMATION
-- Customer_Name   : Customer's Name
-- Customer_Id  : Unique Id of Customers
-- Segment : Product Segment
-- Country : United States
-- City : City of the product ordered
-- State : State of product ordered
-- Product_Id : Unique Product ID
-- Category : Product category
-- Sub_Category : Product sub category
-- Product_Name : Name of the product
-- Sales : Sales contribution of the order
-- Quantity : Quantity Ordered
-- Discount : % discount given
-- Profit : Profit for the order
-- Discount_Amount : discount  amount of the product 
-- Customer Duration : New or Old Customer
-- Returned_Item :  whether item returned or not
-- Returned_Reason : Reason for returning the item

/* row count of data */
select count(*) as row_count from tanu.storee;            #5406



/* Check Dataset Information */
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'storee';



/*  get column names of store data */
select column_name
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='storee';

#count total columns
select count(column_name)
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='storee';


/* get column names with data type of store data */
select column_name,data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='storee';

/* checking null values of store data */
/* Using Nested Query */
SELECT * FROM storee
WHERE (select column_name
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='storee') = NULL;

/* Dropping Unnecessary column like Row_ID */
ALTER TABLE storee DROP COLUMN row_id;
select * from storee limit 10;

/* Check the count of United States */
select count(*) AS US_Count 
from storee
where country = 'United States';
/* This row isn't important for modeling purposes, but important for auto-generating latitude and longitude on Tableau. So, We won't drop it.*/
#all countries are US in this dataset


/* -----------------------------------------------------------------PRODUCT LEVEL ANALYSIS-----------------------------------------------------------------*/
                                                             
                                                             
/* What are the unique product categories? */
select distinct(Category) from storee;



/* What is the number of products in each category? */
SELECT Category, count(*) AS No_of_Products
FROM storee
GROUP BY Category
order by  count(*) desc;

/* Find the number of Subcategories products that are divided. */
select count(distinct (Sub_Category)) As No_of_Sub_Categories
from storee;

select distinct (Sub_Category) As count_of_Sub_Categories
from storee;

/* Find the number of products in each sub-category. */
SELECT Sub_Category, count(*) As No_of_products
FROM storee
GROUP BY Sub_Category
order by  count(*) desc;

/* Find the number of unique product names. */
select count(distinct (Product_Name)) As No_of_unique_products
from storee;

/* Which are the Top 10 Products that are ordered frequently? */
select Product_Name,count(*) from storee
group by Product_Name
order by  count(*) desc
limit 10;

/* Calculate the cost for each Order_ID with respective Product Name. */
select Order_ID,Product_Name,(round((Sales-Profit),2)) as cost from storee;

/* Calculate % profit for each Order_ID with respective Product Name. */
select Order_ID,Product_Name,(round(profit/((Sales-Profit))*100)) as profit_percent from storee;

/* Calculate the overall profit of the store. */
select Category,sum(Profit) from storee
group by Category;
select ROUND(((SUM(profit)/((sum(sales)-sum(profit))))*100)) as percentage_profit  from storee;


/* Calculate percentage profit and group by them with Product Name and Order_Id. */
select (round(profit/((sales-profit))*100)) as percentage_profit,order_id,Product_Name from storee
group by percentage_profit,Product_Name,order_id;

-- the average sales on any given product
SELECT (round(AVG(sales),2)) as average_sale,Product_Name 
FROM storee
group by Product_Name;

-- the average profit on any given product
SELECT (round(AVG(Profit),2)) as average_profit,Product_Name 
FROM storee
group by Product_Name;

-- Average sales per sub-cat
SELECT (round(AVG(Sales-Profit),2)) as average_sales,Sub_Category
FROM storee
group by Sub_Category
order by average_sales desc
limit 5;

-- Average profit per sub-cat
SELECT (round(AVG(Profit),2)) as average_profit,Sub_Category
FROM storee
group by Sub_Category
order by average_profit desc
limit 5;

/* -------------------------------------------------------------------CUSTOMER LEVEL ANALYSIS--------------------------------------------------------------*/

/* What is the number of unique customer IDs? */
select count(distinct(Customer_ID)) from storee;

/* Find those customers who registered during 2014-2016. */
select distinct (Customer_Name), Customer_ID, Order_ID,city, Postal_Code
from storee
where Customer_Id is not null;

/* Calculate Total Frequency of each order id by each customer Name in descending order. */
select order_id, customer_name, count(Order_Id) as total_order_id
from storee
group by order_id,customer_name
order by total_order_id desc;

/* Calculate  cost of each customer name. */
select Customer_name,(sum(sales-profit)) as cost from storee
group by customer_name;

/* Display No of Customers in each region in descending order. */
select count(customer_name),region from storee
group by region;

/* Find Top 10 customers who order frequently. */
select customer_name ,(count(sales)) as order_count from storee
group by customer_name
order by order_count desc
limit 10;

/* Display the records for customers who live in state California and Have postal code 90032. */
select * from storee
where states='California' and postal_code=90032
group by customer_name;

/* Find Top 20 Customers who benefitted the store.*/
SELECT Customer_Name, Profit, City, States
FROM storee
GROUP BY Customer_Name,Profit,City,States
order by  Profit desc
limit 20;

/*-------------------------------------------------------------------------- ORDER LEVEL ANALYSIS--------------------------- --------------------------*/

/* number of unique orders */
select count(distinct(order_ID)) as unique_order from storee;

/* Find Sum Total Sales of Superstore. */
select (round(SUM(sales))) as Total_Sales
from storee;

/* Calculate the time taken for an order to ship and converting the no. of days in int format. */
select customer_name, (ship_date-order_date) as delivery_duration
from storee
order by delivery_duration desc
limit 20;

/* Extract the year  for respective order ID and Customer ID with quantity. */
select order_id,customer_id,quantity,EXTRACT(YEAR from Order_Date) 
from storee
group by order_id,customer_id,quantity,EXTRACT(YEAR from Order_Date) 
order by quantity desc;

/* What is the Sales impact? */
SELECT customer_name,EXTRACT(YEAR from Order_Date), Sales, round(((profit/((sales-profit))*100))) as profit_percentage
FROM storee
GROUP BY EXTRACT(YEAR from Order_Date), Sales, profit_percentage
order by  profit_percentage 
limit 20;
#--Breakdown by Top vs Worst Sellers:


-- Find Top 10 Categories (with the addition of best sub-category within the category).:
SELECT  Category, Sub_Category , round(SUM(sales)) AS prod_sales
FROM storee
GROUP BY Category,Sub_Category
ORDER BY prod_sales DESC;

#--Find Top 10 Sub-Categories. :
SELECT round(SUM(sales)) AS prod_sales,Sub_Category
FROM storee
GROUP BY Sub_Category
ORDER BY prod_sales DESC
limit 10;

#--Find Worst 10 Categories.:
SELECT round(SUM(sales)) AS prod_sales, Category, Sub_Category
FROM storee
GROUP BY Category, Sub_Category
ORDER BY prod_sales;

#-- Find Worst 10 Sub-Categories. :
SELECT round(SUM(sales)) AS prod_sales, sub_Category
FROM storee
GROUP BY Sub_Category
ORDER BY prod_sales
limit 10;

/* Show the Basic Order information. */
select count(Order_ID) as Purchases,
round((sum(Sales))) as Total_Sales,
round(sum(((profit/((sales-profit))*100)))/ count(*)) as avg_percentage_profit,
min(Order_date) as first_purchase_date,
max(Order_date) as Latest_purchase_date,
count(distinct(Product_Name)) as Products_Purchased,
count(distinct(City)) as Location_count
from storee;

/*-------------------------------------------------------------------- RETURN LEVEL ANALYSIS------------------------------------------------------------- */
/* Find the number of returned orders. */
select Returned_items, count(Returned_items)as Returned_Items_Count
from storee
group by Returned_items
Having Returned_items='Returned';

#--Find Top 10 Returned Categories.:
SELECT Returned_items, Count(Returned_items) as no_of_returned ,Category, Sub_Category
FROM storee
GROUP BY Returned_items,Category,Sub_Category
Having Returned_items='Returned'
ORDER BY count(Returned_items) DESC
limit 10;

#-- Find Top 10  Returned Sub-Categories.:
SELECT Returned_items, Count(Returned_items),Sub_Category
FROM storee
GROUP BY Returned_items, Sub_Category
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 10;

#--Find Top 10 Customers Returned Frequently.:
SELECT Returned_items, Count(Returned_items) As Returned_Items_Count, Customer_Name, Customer_ID,Customer_duration, States,City
FROM storee
GROUP BY Returned_items,Customer_Name, Customer_ID,customer_duration,states,city
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 10;

-- Find Top 20 cities and states having higher return.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,States,City
FROM storee
GROUP BY Returned_items,states,city
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 20;


#--Check whether new customers are returning higher or not.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,Customer_duration
FROM storee
GROUP BY Returned_items,Customer_duration
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 20;

#--Find Top  Reasons for returning.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,return_reason
FROM storee
GROUP BY Returned_items,return_reason
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
