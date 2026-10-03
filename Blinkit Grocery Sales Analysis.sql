CREATE database Blinkit;
show databases;
Use Blinkit;


select * from blinkit;
SELECT COUNT(*) from blinkit;


--  ***********Data Cleaning****************

-- Check for inconsistent fat content labels

select DISTINCT Item_Fat_Content from blinkit;

-- Standardise: 'LF' and 'low fat' → 'Low Fat', 'reg' → 'Regular'

UPDATE blinkit SET Item_Fat_Content = 'Low Fat'
WHERE Item_Fat_Content IN ('LF', 'low fat');

UPDATE blinkit SET Item_Fat_Content = 'Regular'
WHERE Item_Fat_Content = 'reg';

-- -- Query To Check Data has been cleaned or not
select DISTINCT Item_Fat_Content from blinkit;


-- **********KPI'S**************

--  1.Total Sales Revenue
SELECT ROUND(SUM(Item_Outlet_Sales),0) as total_sales
from blinkit;

-- 2: Average Sales per item
SELECT ROUND(AVG(Item_Outlet_Sales),0) as avg_sales
from blinkit;

-- 3: Total number of items
SELECT COUNT(*) as total_items
FROM blinkit;

-- 4: Total number of item type of each group
SELECT Item_Type, 
	COUNT(Item_Type) as total_item_type
FROM blinkit
GROUP BY Item_Type;

-- 5. Total Outlet type of each category
SELECT Outlet_Type, 
	COUNT(Outlet_Type) as total_outlet_type
FROM blinkit
GROUP BY Outlet_Type;

-- 6. Total revenue of each outlet
SELECT Outlet_Type, 
	ROUND(SUM(Item_Outlet_Sales),2) as outlet_sales
from blinkit
GROUP BY Outlet_Type;



-- Q1: Sales by Fat Content — do customers prefer Low Fat?
SELECT Item_Fat_Content,
	ROUND(SUM(Item_Outlet_Sales),2) As total_sales,
    COUNT(*) as item_count
FROM blinkit
GROUP BY Item_Fat_Content;

-- Q2: Which item types generate the most revenue?
SELECT Item_Type,
	ROUND(SUM(Item_Outlet_Sales),2) as total_sales,
    COUNT(*) as item_count
FROM blinkit
GROUP BY Item_Type
ORDER BY total_sales DESC;
    
-- Q3: Sales performance by outlet size
SELECT Outlet_Size,
       ROUND(SUM(ITEM_Outlet_Sales), 2) AS total_sales,
       COUNT(*) AS outlet_count,
       ROUND(AVG(ITEM_Outlet_Sales), 2) AS avg_sales_per_item
FROM blinkit
GROUP BY Outlet_Size
ORDER BY total_sales DESC;

-- Q4: Which location tier performs best?
SELECT Outlet_Location_Type,
	ROUND(SUM(Item_Outlet_Sales),2) as total_sales
FROM blinkit
GROUP BY Outlet_Location_Type
ORDER BY total_sales DESC;

-- Q5: Sales by outlet type
SELECT Outlet_Type,
	ROUND(SUM(Item_Outlet_Sales),2) as total_sales,
    COUNT(*) as item_count,
    ROUND(AVG(Item_Outlet_Sales),2) as avg_sales
FROM blinkit
GROUP BY Outlet_Type
ORDER BY total_sales DESC;
    
-- Q6: Top 10 highest selling items by MRP range
SELECT
  CASE
	WHEN Item_MRP < 50 THEN 'Budget (Under 50)'
    WHEN Item_MRP BETWEEN 50 AND 100 THEN 'Mid (50-100)'
    WHEN Item_MRP BETWEEN 100 AND 200 THEN 'Premimum (100-200)'
    ELSE 'Luxury (200+)'
    END AS price_range,
    COUNT(*) as item_count,
    ROUND(SUM(Item_Outlet_Sales),2) as total_sales
FROM blinkit
GROUP BY price_range
ORDER BY total_sales DESC;
    
-- Q7: Best performing outlet type + location combo
SELECT Outlet_Type, Outlet_Location_Type,
	ROUND(SUM(Item_Outlet_Sales),2) as total_sales
FROM blinkit
GROUP BY Outlet_Type, Outlet_Location_Type
ORDER BY total_sales DESC
LIMIT 10;

-- Q8. Percentage of Sales by Outlet Size
SELECT Outlet_Size,
	ROUND(SUM(Item_Outlet_Sales),2) as total_sales,
    ROUND(SUM(Item_Outlet_Sales) * 100.0 / SUM(SUM(Item_Outlet_Sales)) OVER(),2) as sales_percentage
FROM blinkit
GROUP BY Outlet_Size
ORDER BY total_sales DESC;

-- Q9. All Metrics by Outlet Type
SELECT Outlet_Type,
	ROUND(SUM(Item_Outlet_Sales),2) as total_sales,
    ROUND(AVG(Item_Outlet_Sales),2) as avg_sales,
    COUNT(*) as no_of_items,
    ROUND(AVG(Item_Visibility),2) as item_visibility
FROM blinkit
GROUP BY Outlet_Type
ORDER BY total_sales DESC;