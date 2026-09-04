India KPI Analysis
KPI 1: Total Sales (India)
SELECT 
    ROUND(SUM(sales),2) AS india_total_sales
FROM india_orders;

KPI 2: Total Orders (India)
SELECT 
    COUNT(DISTINCT order_id) AS india_total_orders
FROM india_orders;

KPI 3: Total Customers (India Orders)
SELECT 
    COUNT(DISTINCT customer_id) AS india_total_customers
FROM india_orders;

KPI 4: Total Products (India)
SELECT 
    COUNT(DISTINCT product_card_id) AS india_total_products
FROM india_products;

KPI 5: Average Order Value (India)
SELECT 
    ROUND(
        SUM(sales) / COUNT(DISTINCT order_id),
        2
    ) AS india_average_order_value
FROM india_orders;

KPI 6: Total Profit (India)
SELECT 
    ROUND(SUM(benefit_per_order),2) AS india_total_profit
FROM india_orders;

KPI 7: Profit Margin % (India)
SELECT 
    ROUND(
        (SUM(benefit_per_order) / SUM(sales)) * 100,
        2
    ) AS india_profit_margin_percentage
FROM india_orders;

KPI 8: Late Delivery Rate (India)
SELECT 
    ROUND(
        AVG(late_delivery_risk) * 100,
        2
    ) AS india_late_delivery_rate_percentage
FROM india_orders;

KPI 9: Average Actual Shipping Days (India)
SELECT 
    ROUND(AVG(days_for_shipping_real),2) 
    AS india_average_shipping_days
FROM india_orders;

KPI 10: Average Scheduled Shipping Days (India)
SELECT 
    ROUND(AVG(days_for_shipment_scheduled),2)
    AS india_average_scheduled_shipping_days
FROM india_orders;

KPI 11: On-Time Delivery Rate (India)
SELECT 
    ROUND(
        (1 - AVG(late_delivery_risk)) * 100,
        2
    ) AS india_on_time_delivery_rate
FROM india_orders;

step 1 :Delivery Performance
1: Delivery Status Distribution
SELECT
    delivery_status,
    COUNT(*) AS total_orders
FROM india_orders
GROUP BY delivery_status
ORDER BY total_orders DESC;

2: Order Status Distribution
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM india_orders
GROUP BY order_status
ORDER BY total_orders DESC;

3: Shipping Mode Performance
SELECT
    shipping_mode,
    COUNT(*) AS total_orders,
    ROUND(AVG(days_for_shipping_real),2) AS avg_shipping_days,
    ROUND(AVG(late_delivery_risk)*100,2) AS late_delivery_rate
FROM india_orders
GROUP BY shipping_mode
ORDER BY late_delivery_rate DESC;

SELECT
    order_state,
    COUNT(*) AS total_orders,
    SUM(CASE 
            WHEN late_delivery_risk = 1 
            THEN 1 
            ELSE 0 
        END) AS late_orders,
    ROUND(
        AVG(late_delivery_risk)*100,
        2
    ) AS late_delivery_rate
FROM india_orders
GROUP BY order_state
HAVING COUNT(*) > 50
ORDER BY late_delivery_rate DESC;

5: City-wise Delivery Delay
SELECT
    order_city,
    COUNT(*) AS total_orders,
    ROUND(AVG(late_delivery_risk)*100,2) AS late_delivery_rate
FROM india_orders
GROUP BY order_city
HAVING COUNT(*) > 50
ORDER BY late_delivery_rate DESC;

Step 2: India Sales & Business Performance.
1:State-wise Sales 💰
SELECT
    order_state,
    ROUND(SUM(sales), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(sales), 2) AS avg_order_value
FROM india_orders
GROUP BY order_state
ORDER BY total_sales DESC;

2.City-wise Sales Analysis.
SELECT
    order_city,
    ROUND(SUM(sales), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(sales), 2) AS avg_order_value
FROM india_orders
GROUP BY order_city
ORDER BY total_sales DESC;

3.Monthly Sales Trend.
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month_number,
    TO_CHAR(order_date, 'Month') AS month,
    ROUND(SUM(sales), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
FROM india_orders
WHERE order_date IS NOT NULL
GROUP BY
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date),
    TO_CHAR(order_date, 'Month')
ORDER BY
    year,
    month_number;
4.Customer Segment Contribution.
SELECT
    c.customer_segment,
    ROUND(SUM(o.sales), 2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.benefit_per_order), 2) AS total_profit,
    ROUND(AVG(o.sales), 2) AS avg_order_value
FROM india_orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_sales DESC;

Step 3 — Product Performance 🛒.
1.Category Performance
SELECT
    p.category_name,
    ROUND(SUM(o.sales), 2) AS total_sales,
    SUM(o.order_item_quantity) AS total_quantity,
    ROUND(SUM(o.benefit_per_order), 2) AS total_profit
FROM india_orders o
JOIN products p
    ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY total_sales DESC;

2.Top Products by Sales
SELECT
    p.product_name,
    ROUND(SUM(o.sales), 2) AS total_sales,
    SUM(o.order_item_quantity) AS quantity_sold
FROM india_orders o
JOIN products p
    ON o.product_card_id = p.product_card_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

3.Product Profitability
SELECT
    p.category_name,
    ROUND(SUM(o.benefit_per_order), 2) AS total_profit,
    ROUND(AVG(o.benefit_per_order), 2) AS avg_profit
FROM india_orders o
JOIN products p
    ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY total_profit DESC;

4.Sales Volume
SELECT
    p.category_name,
    SUM(o.order_item_quantity) AS quantity_sold
FROM india_orders o
JOIN products p
    ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY quantity_sold DESC;

5.Product Status
SELECT
    product_status,
    COUNT(*) AS total_products
FROM products
GROUP BY product_status
ORDER BY product_status;

;

