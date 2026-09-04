
INDIA INVESTIGATION:
step 1: State vs City Delay
SELECT
    o.order_state,
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
    ) AS city_delay_rate

FROM india_orders o

GROUP BY
    o.order_state,
    o.order_city

HAVING COUNT(DISTINCT o.order_id) >= 20

ORDER BY
    city_delay_rate DESC;

2.State vs City comparison
SELECT o.order_state, o.order_city,
ROUND(AVG(o.late_delivery_risk)*100,2) AS city_delay,
ROUND(AVG(AVG(o.late_delivery_risk)) OVER(PARTITION BY o.order_state)*100,2) AS state_delay,
ROUND((AVG(o.late_delivery_risk)-AVG(AVG(o.late_delivery_risk)) OVER(PARTITION BY o.order_state))*100,2) AS difference
FROM india_orders o
GROUP BY o.order_state, o.order_city
HAVING COUNT(DISTINCT o.order_id) >= 20
ORDER BY difference DESC;

3.Shipping Mode × City
SELECT
    order_city,
    shipping_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(late_delivery_risk)*100,2) AS delay_rate
FROM india_orders
GROUP BY order_city, shipping_mode
HAVING COUNT(DISTINCT order_id) >= 20
ORDER BY delay_rate DESC;

4.Product Category Delay Analysis.
SELECT
    p.category_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.late_delivery_risk) AS late_orders,
    ROUND(AVG(o.late_delivery_risk)*100,2) AS delay_rate
FROM india_orders o
JOIN products p ON o.product_card_id = p.product_card_id
GROUP BY p.category_name
ORDER BY delay_rate DESC;

5.Product Category × City Delay Analysis
SELECT p.category_name, o.order_city,
COUNT(DISTINCT o.order_id) AS orders,
ROUND(AVG(o.late_delivery_risk)*100,2) AS delay_rate
FROM india_orders o
JOIN products p ON o.product_card_id=p.product_card_id
WHERE p.category_name IN ('Women''s Apparel','Men''s Footwear','Cleats','Fishing','Indoor/Outdoor Games','Water Sports','Camping & Hiking')
GROUP BY p.category_name,o.order_city
HAVING COUNT(DISTINCT o.order_id)>=10
ORDER BY delay_rate DESC;

6.Monthly Delivery Delay
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    TO_CHAR(order_date, 'Month') AS month_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(late_delivery_risk)*100,2) AS delay_rate
FROM india_orders
WHERE order_date IS NOT NULL
GROUP BY year, month, month_name
ORDER BY year, month;

7.Customer Segment × City Delay
SELECT o.order_city, c.customer_segment,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(AVG(o.late_delivery_risk)*100,2) AS delay_rate
FROM india_orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_city IN ('Vadodara','Bhavnagar')
GROUP BY o.order_city, c.customer_segment
ORDER BY o.order_city, delay_rate DESC;

8.Shipping Mode × City Delay
SELECT order_city, shipping_mode,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(late_delivery_risk)*100,2) AS delay_rate
FROM india_orders
WHERE order_city IN ('Vadodara','Bhavnagar')
GROUP BY order_city, shipping_mode
ORDER BY order_city, delay_rate DESC;

9.Standard Class — Vadodara vs Bhavnagar
SELECT o.order_city, p.category_name,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(AVG(o.late_delivery_risk)*100,2) AS delay_rate
FROM india_orders o
JOIN india_products p ON o.product_card_id = p.product_card_id
WHERE o.order_city IN ('Vadodara','Bhavnagar')
  AND o.shipping_mode IN ('Standard Class','Standard  Class')
GROUP BY o.order_city, p.category_name
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY o.order_city, delay_rate DESC;

10.Standard Class — Actual vs Scheduled Shipping Vadodara vs Bhavnagar
SELECT order_city,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,
       ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days
FROM india_orders
WHERE order_city IN ('Vadodara','Bhavnagar')
  AND shipping_mode IN ('Standard Class','Standard  Class')
GROUP BY order_city;

11.Standard Class — Order Volume Comparison
SELECT order_city,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(AVG(order_item_quantity),2) AS avg_quantity
FROM india_orders
WHERE order_city IN ('Vadodara','Bhavnagar')
  AND shipping_mode IN ('Standard Class','Standard  Class')
GROUP BY order_city;

12.Standard Class — Order Status Comparison
SELECT order_city, order_status,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(late_delivery_risk)*100,2) AS delay_rate
FROM india_orders
WHERE order_city IN ('Vadodara','Bhavnagar')
  AND shipping_mode IN ('Standard Class','Standard  Class')
GROUP BY order_city, order_status
ORDER BY order_city, delay_rate DESC;

13.Standard Class → delivery_status for Vadodara vs Bhavnagar.
SELECT order_city, delivery_status,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(late_delivery_risk)*100,2) AS delay_rate
FROM india_orders
WHERE order_city IN ('Vadodara','Bhavnagar')
  AND shipping_mode IN ('Standard Class','Standard  Class')
GROUP BY order_city, delivery_status
ORDER BY order_city, delay_rate DESC;

14.Compare Actual vs Scheduled for Late vs Non-Late
SELECT delivery_status,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,
       ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,
       ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled),2) AS avg_gap
FROM india_orders
WHERE order_city = 'Vadodara'
  AND shipping_mode IN ('Standard Class','Standard  Class')
GROUP BY delivery_status
ORDER BY delivery_status;

15.late vs non-late Standard Class orders in Vadodara.
SELECT delivery_status,
       days_for_shipping_real,
       COUNT(DISTINCT order_id) AS orders
FROM india_orders
WHERE order_city = 'Vadodara'
  AND shipping_mode IN ('Standard Class','Standard  Class')
GROUP BY delivery_status, days_for_shipping_real
ORDER BY delivery_status, days_for_shipping_real;


16.First Class Delivery Performance in India
SELECT order_city,
       COUNT(DISTINCT order_id) AS total_orders,
       COUNT(DISTINCT order_id) FILTER (WHERE delivery_status = 'Late delivery') AS late_orders,
       ROUND(
           COUNT(DISTINCT order_id) FILTER (WHERE delivery_status = 'Late delivery') * 100.0
           / COUNT(DISTINCT order_id), 2
       ) AS delay_pct
FROM india_orders
WHERE shipping_mode = 'First Class'
GROUP BY order_city
ORDER BY delay_pct DESC;

17.First Class: Actual vs Scheduled Shipping Time
SELECT delivery_status,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,
       ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,
       ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled),2) AS avg_gap
FROM india_orders
WHERE shipping_mode = 'First Class'
GROUP BY delivery_status
ORDER BY delivery_status;



18.2nd class Actual vs Scheduled shipping time
SELECT delivery_status,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,
       ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,
       ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled),2) AS avg_gap
FROM india_orders
WHERE shipping_mode = 'Second Class'
GROUP BY delivery_status
ORDER BY delivery_status;

19.India-wide shipping mode performance
SELECT shipping_mode,
       delivery_status,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,
       ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,
       ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled),2) AS avg_gap
FROM india_orders
GROUP BY shipping_mode, delivery_status
ORDER BY shipping_mode, delivery_status;

20.City-Level Shipping Delay Hotspots in India
SELECT order_city,
       shipping_mode,
       COUNT(DISTINCT order_id) AS total_orders,
       COUNT(DISTINCT order_id) FILTER (
           WHERE delivery_status = 'Late delivery'
       ) AS late_orders,
       ROUND(
           COUNT(DISTINCT order_id) FILTER (
               WHERE delivery_status = 'Late delivery'
           ) * 100.0 / COUNT(DISTINCT order_id), 2
       ) AS delay_pct,
       ROUND(AVG(days_for_shipping_real),2) AS avg_actual_days,
       ROUND(AVG(days_for_shipment_scheduled),2) AS avg_scheduled_days,
       ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled),2) AS avg_gap
FROM india_orders
GROUP BY order_city, shipping_mode
HAVING COUNT(DISTINCT order_id) >= 10
ORDER BY delay_pct DESC, total_orders DESC;

21.Customer Segment vs Delivery Delay in India
SELECT c.customer_segment,
       COUNT(DISTINCT o.order_id) AS total_orders,
       COUNT(DISTINCT o.order_id) FILTER (
           WHERE o.delivery_status = 'Late delivery'
       ) AS late_orders,
       ROUND(
           COUNT(DISTINCT o.order_id) FILTER (
               WHERE o.delivery_status = 'Late delivery'
           ) * 100.0
           / COUNT(DISTINCT o.order_id), 2
       ) AS delay_pct
FROM customers c
JOIN india_orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
ORDER BY delay_pct DESC;

22.Discount vs Delivery Delay in India
SELECT
    CASE
        WHEN order_item_discount > 0 THEN 'Discounted'
        ELSE 'Non-discounted'
    END AS discount_status,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT order_id) FILTER (
        WHERE delivery_status = 'Late delivery'
    ) AS late_orders,

    ROUND(
        COUNT(DISTINCT order_id) FILTER (
            WHERE delivery_status = 'Late delivery'
        ) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS delay_pct

FROM india_orders

GROUP BY discount_status
ORDER BY delay_pct DESC;

23.Order Status → Delivery Delay.
SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT order_id) FILTER (
        WHERE delivery_status = 'Late delivery'
    ) AS late_orders,

    ROUND(
        COUNT(DISTINCT order_id) FILTER (
            WHERE delivery_status = 'Late delivery'
        ) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS delay_pct

FROM india_orders

GROUP BY order_status
ORDER BY delay_pct DESC;


24.City + Shipping Mode root-cause query.
SELECT
    order_city,
    shipping_mode,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT order_id) FILTER (
        WHERE delivery_status = 'Late delivery'
    ) AS late_orders,

    ROUND(
        COUNT(DISTINCT order_id) FILTER (
            WHERE delivery_status = 'Late delivery'
        ) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS delay_pct,

    ROUND(
        AVG(days_for_shipping_real)::numeric,
        2
    ) AS avg_actual_shipping_days,

    ROUND(
        AVG(days_for_shipment_scheduled)::numeric,
        2
    ) AS avg_scheduled_shipping_days,

    ROUND(
        AVG(
            days_for_shipping_real
            - days_for_shipment_scheduled
        )::numeric,
        2
    ) AS avg_shipping_gap

FROM india_orders

GROUP BY
    order_city,
    shipping_mode

HAVING COUNT(DISTINCT order_id) >= 20

ORDER BY
    delay_pct DESC,
    avg_shipping_gap DESC;

	
25.s scheduled time fixed by shipping mode?
SELECT
    shipping_mode,
    MIN(days_for_shipment_scheduled) AS min_scheduled_days,
    MAX(days_for_shipment_scheduled) AS max_scheduled_days,
    COUNT(DISTINCT days_for_shipment_scheduled) AS different_scheduled_days
FROM india_orders
GROUP BY shipping_mode
ORDER BY shipping_mode;
	
26.India → Customer country
SELECT
    o.order_country,
    c.customer_country,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM india_orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY
    o.order_country,
    c.customer_country
ORDER BY total_orders DESC;

27.Same State vs Different State × Shipping Mode
SELECT
    o.shipping_mode,

    CASE
        WHEN o.order_state = c.customer_state
            THEN 'Same State'
        ELSE 'Different State'
    END AS route_type,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.delivery_status = 'Late delivery'
    ) AS late_orders,

    ROUND(
        COUNT(DISTINCT o.order_id) FILTER (
            WHERE o.delivery_status = 'Late delivery'
        ) * 100.0
        / COUNT(DISTINCT o.order_id),
        2
    ) AS delay_rate,

    ROUND(AVG(o.days_for_shipping_real), 2) AS avg_actual_days,

    ROUND(AVG(o.days_for_shipment_scheduled), 2) AS avg_scheduled_days,

    ROUND(
        AVG(
            o.days_for_shipping_real
            - o.days_for_shipment_scheduled
        ),
        2
    ) AS avg_gap

FROM india_orders o

JOIN customers c
    ON o.customer_id = c.customer_id

GROUP BY
    o.shipping_mode,
    route_type

ORDER BY
    o.shipping_mode,
    delay_rate DESC;

28.Customer State vs Order State directly
SELECT
    o.shipping_mode,
    o.order_state,
    c.customer_state,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.delivery_status = 'Late delivery'
    ) AS late_orders,

    ROUND(
        COUNT(DISTINCT o.order_id) FILTER (
            WHERE o.delivery_status = 'Late delivery'
        ) * 100.0
        / COUNT(DISTINCT o.order_id),
        2
    ) AS delay_rate,

    ROUND(AVG(o.days_for_shipping_real), 2) AS avg_actual_days,

    ROUND(AVG(o.days_for_shipment_scheduled), 2) AS avg_scheduled_days,

    ROUND(
        AVG(
            o.days_for_shipping_real
            - o.days_for_shipment_scheduled
        ),
        2
    ) AS avg_gap

FROM india_orders o

JOIN customers c
    ON o.customer_id = c.customer_id

GROUP BY
    o.shipping_mode,
    o.order_state,
    c.customer_state

HAVING COUNT(DISTINCT o.order_id) >= 10

ORDER BY delay_rate DESC;

29.shipping performance by mode
SELECT
    shipping_mode,
    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(AVG(days_for_shipping_real), 2) AS avg_actual_days,

    ROUND(AVG(days_for_shipment_scheduled), 2) AS avg_scheduled_days,

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

30 — Why Did January 2018 Sales Decline Despite Higher Order Volume?
with product_comparison AS (
    SELECT
        p.product_name,
        ROUND(
            SUM(
                CASE
                    WHEN EXTRACT(YEAR FROM o.order_date) = 2017
                     AND EXTRACT(MONTH FROM o.order_date) = 12
                    THEN o.sales
                    ELSE 0
                END
            ),
            2
        ) AS december_sales,

        ROUND(
            SUM(
                CASE
                    WHEN EXTRACT(YEAR FROM o.order_date) = 2018
                     AND EXTRACT(MONTH FROM o.order_date) = 1
                    THEN o.sales
                    ELSE 0
                END
            ),
            2
        ) AS january_sales

    FROM india_orders o
    JOIN products p
        ON o.product_card_id = p.product_card_id

    WHERE o.order_date IS NOT NULL
      AND (
            (
                EXTRACT(YEAR FROM o.order_date) = 2017
                AND EXTRACT(MONTH FROM o.order_date) = 12
            )
            OR
            (
                EXTRACT(YEAR FROM o.order_date) = 2018
                AND EXTRACT(MONTH FROM o.order_date) = 1
            )
          )

    GROUP BY p.product_name
)

SELECT
    product_name,
    december_sales,
    january_sales,
    ROUND(january_sales - december_sales, 2) AS sales_change
FROM product_comparison
WHERE december_sales > 0
   OR january_sales > 0
ORDER BY ABS(january_sales - december_sales) DESC;

31.India — Delivery Rate Spread: Best vs Worst Cities
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