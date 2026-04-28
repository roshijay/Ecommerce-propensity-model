SELECT 
	product_category_name, 
	COUNT(*) AS total_customers, 
	SUM(CASE WHEN buyer_type = 'repeat' THEN 1 ELSE 0 END) AS repeat_buyers, 
	ROUND(SUM(CASE WHEN buyer_type = 'repeat' THEN 1 ELSE 0 END) * 100.0/COUNT(*), 2) AS repeat_rate
FROM (
	SELECT 
		c.customer_unique_id, 
		p.product_category_name, 
		CASE WHEN COUNT(o.order_id) = 1
			 THEN 'one_time'
			 ELSE 'repeat'
		END AS buyer_type
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id 
	JOIN order_items oi ON o.order_id = oi.order_id 
	JOIN products p ON oi.product_id = p.product_id 
	WHERE o.order_status = 'delivered'
	GROUP BY c.customer_unique_id, p.product_category_name
) category_table
GROUP BY product_category_name 
HAVING COUNT(*) >= 100
ORDER BY repeat_rate DESC;