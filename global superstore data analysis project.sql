create database indexing;
use indexing;
SHOW TABLES;
RENAME TABLE `global superstore 2018 _ csv format` TO `SUPERSTORE`;
SHOW TABLES;
DESCRIBE SUPERSTORE;

-- total revenue
SELECT SUM(Sales) AS total_revenue
FROM superstore;

--  2. Find the Segment wise distribution of the Sales.
select segment, sum(segment) as seg_sales
from superstore
group by segment
order by seg_sales desc;

-- 3Find the top 3 most profitable Products.
SELECT 
    "Product Name" AS product_name,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Product_Name
ORDER BY total_profit DESC
LIMIT 3;

-- How many orders are placed after January 2016.
SELECT 
    COUNT(DISTINCT 'Order ID') AS Orders_After_Jan_2016
FROM 
    Superstore
WHERE 
    'Order Date' > '2016-01-31';

-- 5. How many states from austria are under the roof of business
SELECT 
    COUNT(DISTINCT "State") AS no_of_state
FROM superstore
WHERE  Country = 'Austria';



--  6 which products and subcategories are most and least profitable ?
-- Most and least profitable products
(
    SELECT 
        "Product Name" AS product_name,
        SUM(Profit) AS total_profit,
        'Most Profitable' AS category
    FROM superstore
    GROUP BY "Product Name"
    ORDER BY total_profit DESC
    LIMIT 1
)
UNION ALL
(
    SELECT 
        "Product Name" AS product_name,
        SUM(Profit) AS total_profit,
        'Least Profitable' AS category
    FROM superstore
    GROUP BY "Product Name"
    ORDER BY total_profit ASC
    LIMIT 1
);

-- Which customer segment contributes the most to the total revenue?

SELECT 
    Segment,
    SUM(Sales) AS total_revenue
FROM superstore
GROUP BY Segment
ORDER BY total_revenue DESC
LIMIT 1;

-- 8. What is the year-over-year growth in sales and Profit?
SELECT 
    EXTRACT(YEAR FROM DATE("Order Date")) AS order_year,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(
        (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY EXTRACT(YEAR FROM DATE("Order Date")))) 
        / LAG(SUM(Sales)) OVER (ORDER BY EXTRACT(YEAR FROM DATE("Order Date"))) * 100, 2
    ) AS sales_growth_percent,
    ROUND(
        (SUM(Profit) - LAG(SUM(Profit)) OVER (ORDER BY EXTRACT(YEAR FROM DATE("Order Date")))) 
        / LAG(SUM(Profit)) OVER (ORDER BY EXTRACT(YEAR FROM DATE("Order Date"))) * 100, 2
    ) AS profit_growth_percent
FROM superstore
GROUP BY EXTRACT(YEAR FROM DATE("Order Date"))
ORDER BY order_year;

-- 9. Which countries and cities are driving the highest sales?
-- Top 5 countries
SELECT 
    Country,
    SUM(Sales) AS total_sales
FROM global_superstore
GROUP BY Country
ORDER BY total_sales DESC
LIMIT 5;

-- Top 5 cities
SELECT 
    City,
    Country,
    SUM(Sales) AS total_sales
FROM superstore
GROUP BY Country, City
ORDER BY total_sales DESC
LIMIT 5;

-- 10. What is the average delivery time from order to ship date across regions?

SELECT 
    Region,
    ROUND(AVG(DATEDIFF("Ship Date", "Order Date")), 2) AS avg_delivery_days
FROM superstore
GROUP BY Region
ORDER BY avg_delivery_days;

-- 11. what is the profit distribution across order priority?
SELECT 
    "Order Priority",
    SUM(Profit) AS total_profit,
    ROUND(AVG(Profit), 2) AS avg_profit_per_order,
    COUNT(DISTINCT "Order ID") AS order_count
FROM superstore
GROUP BY "Order Priority"
ORDER BY total_profit DESC;

-- 12. Suggest data-driven recommendations for improving profit and reducing losses.
SELECT 
    "Sub-Category",
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Sub-Category"
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC;

SELECT 
    ROUND(Discount, 2) AS discount_level,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY ROUND(Discount, 2)
ORDER BY total_profit ASC;
