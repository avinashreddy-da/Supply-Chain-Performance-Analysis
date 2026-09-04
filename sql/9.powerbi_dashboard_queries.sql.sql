/* ============================================================
   SUPPLY CHAIN PERFORMANCE ANALYSIS
   POWER BI DASHBOARD QUERIES
   ============================================================ */


/* ============================================================
   1. GLOBAL KPI QUERIES
   ============================================================ */

-- KPI 1: Total Sales
SELECT
    ROUND(SUM(sales), 2) AS total_sales
FROM orders;


-- KPI 2: Total Orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- KPI 3: Total Profit
SELECT
    ROUND(SUM(benefit_per_order), 2) AS total_profit
FROM orders;


-- KPI 4: Profit Margin (%)
SELECT
    ROUND(
        (SUM(benefit_per_order) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percentage
FROM orders;


-- KPI 5: Late Delivery Rate (%)
SELECT
    ROUND(
        AVG(late_delivery_risk) * 100,
        2
    ) AS late_delivery_rate_percentage
FROM orders;


-- KPI 6: Average Shipping Days
SELECT
    ROUND(AVG(days_for_shipping_real), 2) AS average_shipping_days
FROM orders;



/* ============================================================
   2. GLOBAL POWER BI CHART QUERIES
   ============================================================ */

-- Chart 1: Sales by Market
SELECT
    o.market,
    ROUND(SUM(o.sales), 2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY o.market
ORDER BY total_sales DESC;


-- Chart 2: Sales Trend Over Time
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month_number,
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
    month_number;


-- Chart 3: Late Delivery Rate by Country
-- Minimum order threshold: 1,000 orders
SELECT
    order_country,
    COUNT(*) AS total_orders,
    ROUND(
        AVG(late_delivery_risk) * 100,
        2
    ) AS late_delivery_rate
FROM orders
GROUP BY order_country
HAVING COUNT(*) > 1000
ORDER BY late_delivery_rate DESC;


-- Chart 4. Product Category Performance
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


-- Chart 5. Sales by Customer Segment
SELECT
    c.customer_segment,
    ROUND(SUM(o.sales),2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_sales DESC;

-- Chart 6: Delivery Risk by Shipping Mode
SELECT
    shipping_mode,
    COUNT(*) AS total_orders,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_shipping_days,
    ROUND(
        AVG(late_delivery_risk) * 100,
        2
    ) AS late_delivery_rate
FROM orders
GROUP BY shipping_mode
ORDER BY late_delivery_rate DESC;



/* ============================================================
   3. INDIA KPI QUERIES
   ============================================================ */

-- KPI 1: Total Sales (India)
SELECT
    ROUND(SUM(sales), 2) AS india_total_sales
FROM india_orders;


-- KPI 2: Total Orders (India)
SELECT
    COUNT(DISTINCT order_id) AS india_total_orders
FROM india_orders;


-- KPI 3: Total Profit (India)
SELECT
    ROUND(SUM(benefit_per_order), 2) AS india_total_profit
FROM india_orders;


-- KPI 4: Profit Margin (%) (India)
SELECT
    ROUND(
        (SUM(benefit_per_order) / SUM(sales)) * 100,
        2
    ) AS india_profit_margin_percentage
FROM india_orders;


-- KPI 5: Late Delivery Rate (%) (India)
SELECT
    ROUND(
        AVG(late_delivery_risk) * 100,
        2
    ) AS india_late_delivery_rate_percentage
FROM india_orders;


-- KPI 6: Average Shipping Days (India)
SELECT
    ROUND(AVG(days_for_shipping_real), 2)
        AS india_average_shipping_days
FROM india_orders;



/* ============================================================
   4. INDIA POWER BI CHART QUERIES
   ============================================================ */

-- Chart 1: Sales & Orders by State
SELECT
    order_state,
    ROUND(SUM(sales), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(sales), 2) AS avg_order_value
FROM india_orders
GROUP BY order_state
ORDER BY total_sales DESC;


-- Chart 2: India — Delivery Rate Spread: Best vs Worst Cities
WITH city_performance AS (
    SELECT
        o.order_city,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.order_id) FILTER (
            WHERE o.late_delivery_risk = 1
        ) AS late_orders,
        ROUND(
            COUNT(DISTINCT o.order_id) FILTER (
                WHERE o.late_delivery_risk = 1
            ) * 100.0
            / COUNT(DISTINCT o.order_id),
            2
        ) AS late_delivery_rate
    FROM india_orders o
    GROUP BY o.order_city
    HAVING COUNT(DISTINCT o.order_id) >= 20
),

best_5 AS (
    SELECT
        order_city,
        total_orders,
        late_orders,
        late_delivery_rate,
        'Lowest 5' AS performance_group
    FROM city_performance
    ORDER BY late_delivery_rate ASC, total_orders DESC
    LIMIT 5
),

worst_5 AS (
    SELECT
        order_city,
        total_orders,
        late_orders,
        late_delivery_rate,
        'Highest 5' AS performance_group
    FROM city_performance
    ORDER BY late_delivery_rate DESC, total_orders DESC
    LIMIT 5
)

SELECT *
FROM best_5

UNION ALL

SELECT *
FROM worst_5

ORDER BY late_delivery_rate;


-- Chart 3: Late Delivery by Category
SELECT
    p.category_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.late_delivery_risk) AS late_orders,
    ROUND(
        AVG(o.late_delivery_risk) * 100,
        2
    ) AS delay_rate
FROM india_orders o
JOIN products p
    ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY delay_rate DESC;


-- Chart 4: Delivery Performance by City & Shipping Mode
-- Minimum order threshold: 20 orders
SELECT
    o.order_city,
    o.shipping_mode,
    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.late_delivery_risk = 1
    ) AS late_orders,

    ROUND(
        COUNT(DISTINCT o.order_id) FILTER (
            WHERE o.late_delivery_risk = 1
        ) * 100.0
        / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_rate,

    ROUND(
        AVG(o.days_for_shipment_scheduled),
        2
    ) AS avg_scheduled_days,

    ROUND(
        AVG(o.days_for_shipping_real),
        2
    ) AS avg_actual_days

FROM india_orders o

GROUP BY
    o.order_city,
    o.shipping_mode

HAVING COUNT(DISTINCT o.order_id) >= 20

ORDER BY
    late_delivery_rate DESC,
    total_orders DESC;


-- Chart 5: Shipping Performance by Mode
SELECT
    shipping_mode,
    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        AVG(days_for_shipping_real),
        2
    ) AS avg_actual_days,

    ROUND(
        AVG(days_for_shipment_scheduled),
        2
    ) AS avg_scheduled_days,

    ROUND(
        AVG(
            days_for_shipping_real
            - days_for_shipment_scheduled
        ),
        2
    ) AS avg_shipping_gap

FROM india_orders

GROUP BY shipping_mode

ORDER BY shipping_mode;