SELECT 
	purchase_frequency, 
	COUNT(*) AS num_customers, 
	ROUND(COUNT (*) * 100.00/ sum(COUNT(*)) OVER (), 2) pct_of_customers
FROM (
	SELECT 
		customer_unique_id, 
		COUNT(o.order_id) AS purchase_frequency
	FROM customers c 
	JOIN orders o ON c.customer_id = o.customer_id 
	WHERE o.order_status = 'delivered'
	GROUP BY c.customer_unique_id 
) freq_table 
GROUP BY purchase_frequency
ORDER BY purchase_frequency;
