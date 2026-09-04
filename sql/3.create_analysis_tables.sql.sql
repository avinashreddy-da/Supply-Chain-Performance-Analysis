
DROP TABLE customers;
DROP TABLE orders;

CREATE TABLE customers AS
SELECT DISTINCT
    customer_id,
    customer_segment,
    customer_city,
    customer_state,
    customer_country
FROM supply_chain;

CREATE TABLE orders AS
SELECT
    order_id,
    order_item_id,
    original_order_item_id,
    customer_id,
    product_card_id,
    order_item_product_id,

    order_date,
    shipping_date,
    shipping_mode,

    order_city,
    order_state,
    order_country,
    order_region,
    market,

    delivery_status,
    order_status,
    late_delivery_risk,

    days_for_shipping_real,
    days_for_shipment_scheduled,

    order_item_quantity,
    order_item_discount,
    order_item_discount_rate,
    order_item_product_price,

    sales,
    sales_per_customer,
    order_item_total,
    benefit_per_order
FROM supply_chain;

SELECT
    product_card_id,
    COUNT(*) AS row_count
FROM products
GROUP BY product_card_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

SELECT *
FROM products
WHERE product_card_id IN (35, 44, 37, 24, 926)
ORDER BY product_card_id;

SELECT
    COUNT(*) AS total_product_rows,
    COUNT(DISTINCT product_card_id) AS unique_product_ids,
    COUNT(*) FILTER (WHERE product_name = 'Unknown') AS unknown_product_rows
FROM supply_chain;

SELECT
    product_card_id,
    COUNT(DISTINCT product_name) AS different_product_names
FROM supply_chain
WHERE product_name IS NOT NULL
  AND product_name <> 'Unknown'
GROUP BY product_card_id
HAVING COUNT(DISTINCT product_name) > 1
ORDER BY different_product_names DESC;

DROP TABLE products;

CREATE TABLE products AS
SELECT DISTINCT ON (product_card_id)
    product_card_id,
    product_category_id,
    category_id,
    category_name,
    department_id,
    department_name,
    product_name,
    product_price,
    product_status
FROM supply_chain
WHERE product_name IS NOT NULL
  AND product_name <> 'Unknown'
ORDER BY product_card_id;

SELECT
    product_card_id,
    COUNT(*)
FROM products
GROUP BY product_card_id
HAVING COUNT(*) > 1;

