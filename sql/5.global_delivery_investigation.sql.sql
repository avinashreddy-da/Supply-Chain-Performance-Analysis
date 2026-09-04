Investigate Delivery Analysis:
Investigation 1: Is the scheduled delivery time realistic?
SELECT
    shipping_mode,
    ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,
    ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,
    ROUND(AVG(days_for_shipping_real) - AVG(days_for_shipment_scheduled),2) AS avg_delay_days
FROM orders
GROUP BY shipping_mode
ORDER BY avg_delay_days DESC;

Investigation 2: Location causing delivery delays
SELECT
    order_region,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN late_delivery_risk = 1 THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN late_delivery_risk = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS late_delivery_rate
FROM orders
GROUP BY order_region
ORDER BY late_delivery_rate DESC;

3. Country-wise Delivery
SELECT
    order_country,
    COUNT(*) AS total_orders,
    
    SUM(CASE 
            WHEN late_delivery_risk = 1 
            THEN 1 
            ELSE 0 
        END) AS late_orders,

    ROUND(
        100.0 * SUM(CASE 
                        WHEN late_delivery_risk = 1 
                        THEN 1 
                        ELSE 0 
                    END) / COUNT(*),
        2
    ) AS late_delivery_rate

FROM orders

GROUP BY order_country
HAVING COUNT(*) > 1000

ORDER BY late_delivery_rate DESC;

4.Product Category Delay Analysis
SELECT
    p.category_name,

    COUNT(o.order_id) AS total_orders,

    SUM(
        CASE 
            WHEN o.late_delivery_risk = 1 
            THEN 1 
            ELSE 0 
        END
    ) AS late_orders,

    ROUND(
        100.0 * SUM(
            CASE 
                WHEN o.late_delivery_risk = 1 
                THEN 1 
                ELSE 0 
            END
        ) / COUNT(o.order_id),
        2
    ) AS late_delivery_rate

FROM orders o
JOIN products p
ON o.product_card_id = p.product_card_id

GROUP BY p.category_name

ORDER BY late_delivery_rate DESC;

5.Late Delivery vs Profit Impact
SELECT
    delivery_status,

    COUNT(order_id) AS total_orders,

    ROUND(SUM(sales),2) AS total_sales,

    ROUND(SUM(benefit_per_order),2) AS total_profit,

    ROUND(
        100.0 * SUM(benefit_per_order) / SUM(sales),
        2
    ) AS profit_margin

FROM orders

GROUP BY delivery_status

ORDER BY total_sales DESC;

step 6: Are actual delivery times exceeding the scheduled delivery time?
SELECT
    ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,
    ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,

    ROUND(
        AVG(days_for_shipping_real - days_for_shipment_scheduled),
        2
    ) AS avg_delay_days

FROM orders;

7.Country-wise Delivery Gap.
SELECT
    order_country,

    COUNT(order_id) AS total_orders,

    ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,

    ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,

    ROUND(
        AVG(days_for_shipping_real - days_for_shipment_scheduled),
        2
    ) AS avg_delay_gap

FROM orders

GROUP BY order_country

HAVING COUNT(order_id) >= 100

ORDER BY avg_delay_gap DESC;

8.Customer Segment vs Delivery Delay
SELECT
    c.customer_segment,
    COUNT(o.order_id) AS total_orders,

    SUM(
        CASE
            WHEN o.late_delivery_risk = 1
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.late_delivery_risk = 1
                THEN 1
                ELSE 0
            END
        ) / COUNT(o.order_id),
        2
    ) AS late_delivery_rate

FROM orders o

JOIN customers c
ON o.customer_id = c.customer_id

GROUP BY c.customer_segment

ORDER BY late_delivery_rate DESC;

step 9:Which markets have the highest late delivery rate?
SELECT
    c.market,

    COUNT(o.order_id) AS total_orders,

    SUM(
        CASE
            WHEN o.late_delivery_risk = 1
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.late_delivery_risk = 1
                THEN 1
                ELSE 0
            END
        ) / COUNT(o.order_id),
        2
    ) AS late_delivery_rate

FROM orders o

JOIN customers c
ON o.customer_id = c.customer_id

GROUP BY c.market

ORDER BY late_delivery_rate DESC;

10.Late Delivery Rate by Country
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