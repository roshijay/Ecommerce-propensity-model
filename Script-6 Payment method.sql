SELECT 
	payment_type, 
	COUNT(*) AS total_customers, 
	SUM(CASE WHEN buyer_type = 'repeat' THEN 1 ELSE 0 END) AS repeat_buyers, 
	ROUND(SUM(CASE WHEN buyer_type = 'repeat' THEN 1 ELSE 0 END) * 100.0/COUNT(*), 2) AS repeat_rate
FROM (
	SELECT 
		c.customer_unique_id, 
		oi.payment_type, 
		CASE WHEN COUNT(o.order_id) = 1
			 THEN 'one_time'
			 ELSE 'repeat'
		END AS buyer_type
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id 
	JOIN order_payments oi ON o.order_id = oi.order_id 
	WHERE o.order_status = 'delivered'
	GROUP BY c.customer_unique_id, oi.payment_type
) category_table
GROUP BY payment_type 
HAVING COUNT(*) >= 100
ORDER BY repeat_rate DESC;