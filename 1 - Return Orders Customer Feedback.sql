SELECT 
    o.customer_name, 
    ROUND(COUNT(r.order_id) * 100.0 / COUNT(o.order_id), 2) AS return_percent
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY o.customer_name
HAVING ROUND(COUNT(r.order_id) * 100.0 / COUNT(o.order_id), 2) > 50
ORDER BY o.customer_name;
