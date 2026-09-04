
CREATE TABLE india_orders AS
SELECT *
FROM orders
WHERE order_country = 'India';


CREATE TABLE india_products AS
SELECT DISTINCT p.*
FROM products p
JOIN india_orders o
ON p.product_card_id = o.product_card_id;
