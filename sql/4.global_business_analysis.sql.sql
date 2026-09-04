
# KPI 1: Total Sales

SELECT ROUND(SUM(sales),2) AS total_sales
FROM orders;

#KPI 2: Total Orders
ELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;S

KPI 3: Total Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

KPI 4: Total Products
SELECT COUNT(DISTINCT product_card_id) AS total_products
FROM products;

KPI 5: Average Order Value
SELECT ROUND(SUM(sales) / COUNT(DISTINCT order_id),2) AS average_order_value
FROM orders;

KPI 6: Total Profit
SELECT ROUND(SUM(benefit_per_order),2) AS total_profit
FROM orders;

KPI 7: Profit Margin (%)
SELECT ROUND(
    (SUM(benefit_per_order) / SUM(sales)) * 100,
    2
) AS profit_margin_percentage
FROM orders;

KPI 8: Late Delivery Rate
SELECT ROUND(
    AVG(late_delivery_risk) * 100,
    2
) AS late_delivery_rate_percentage
FROM orders;

(late_delivery_risk is 0/1, so averaging it gives the percentage.)

KPI 9: Average Shipping Days
SELECT ROUND(AVG(days_for_shipping_real),2) AS average_shipping_days
FROM orders;

KPI 10: Average Scheduled Shipping Days
SELECT ROUND(AVG(days_for_shipment_scheduled),2) AS average_scheduled_shipping_days
FROM orders;

KPI 11: on time delivery rate
SELECT ROUND(
    (1 - AVG(late_delivery_risk)) * 100,
    2
) AS on_time_delivery_rate
FROM orders;

Step 1: Delivery Performance

1. Delivery Status Distribution

SELECT
    delivery_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY delivery_status
ORDER BY total_orders DESC;

2.Order Status Distribution
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

3.Shipping Mode Performance
SELECT
    shipping_mode,
    COUNT(*) AS total_orders,
    ROUND(AVG(days_for_shipping_real),2) AS avg_shipping_days,
    ROUND(AVG(late_delivery_risk)*100,2) AS late_delivery_rate
FROM orders
GROUP BY shipping_mode
ORDER BY late_delivery_rate DESC;

4. Region-wise Late Delivery
SELECT
    order_region,
    COUNT(*) AS total_orders,
    ROUND(AVG(late_delivery_risk)*100,2) AS late_delivery_rate
FROM orders
GROUP BY order_region
ORDER BY late_delivery_rate DESC;


5. Scheduled vs Actual Shipping
SELECT
    ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,
    ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days
FROM orders;

step 2:SALES ANALYSIS:

1️.Sales by Region
SELECT
    order_region,
    ROUND(SUM(sales),2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(sales),2) AS avg_order_value
FROM orders
GROUP BY order_region
ORDER BY total_sales DESC;

2. Sales by Country
SELECT
    order_country,
    ROUND(SUM(sales),2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY order_country
ORDER BY total_sales DESC
LIMIT 20;

3. Sales by Market
SELECT
    o.market,
    ROUND(SUM(o.sales),2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.market
ORDER BY total_sales DESC;

4. Sales by Customer Segment
SELECT
    c.customer_segment,
    ROUND(SUM(o.sales),2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_sales DESC;

5. Sales by Product Category
SELECT
    p.category_name,
    ROUND(SUM(o.sales),2) AS total_sales,
    SUM(o.order_item_quantity) AS total_quantity
FROM orders o
JOIN products p
ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY total_sales DESC;

6.sales by year and month
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    TO_CHAR(order_date, 'Month') AS month,
    ROUND(SUM(sales), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
WHERE order_date IS NOT NULL
GROUP BY
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date),
    TO_CHAR(order_date, 'Month')
ORDER BY
    year,
    EXTRACT(MONTH FROM order_date);
	
step 3:Products
1. Product Category Performance
SELECT
    p.category_name,
    ROUND(SUM(o.sales),2) AS total_sales,
    SUM(o.order_item_quantity) AS total_quantity,
    ROUND(SUM(o.benefit_per_order),2) AS total_profit
FROM orders o
JOIN products p
ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY total_sales DESC;

2. Top 10 Products by Sales
SELECT
    p.product_name,
    ROUND(SUM(o.sales),2) AS total_sales,
    SUM(o.order_item_quantity) AS quantity_sold
FROM orders o
JOIN products p
ON o.product_card_id = p.product_card_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

3. Product Profitability
SELECT
    p.category_name,
    ROUND(SUM(o.benefit_per_order),2) AS total_profit,
    ROUND(AVG(o.benefit_per_order),2) AS avg_profit
FROM orders o
JOIN products p
ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY total_profit DESC;

4. Quantity Sold by Category
SELECT
    p.category_name,
    SUM(o.order_item_quantity) AS quantity_sold
FROM orders o
JOIN products p
ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY quantity_sold DESC;

5. Product Status Analysis
SELECT
    product_status,
    COUNT(*) AS products
FROM products
GROUP BY product_status;

