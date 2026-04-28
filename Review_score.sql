SELECT 
	buyer_type,
	COUNT(*) AS num_customers,
	ROUND(AVG(avg_review_score), 2) AS avg_review_score
FROM (
	SELECT 
		c.customer_unique_id,
    	CASE WHEN COUNT(o.order_id) = 1
         	 THEN 'one_time'
         	 ELSE 'repeat'
    	END AS buyer_type,
    		AVG(r.review_score) AS avg_review_score  
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	JOIN order_reviews r ON o.order_id = r.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY c.customer_unique_id		
) delivery_table
GROUP BY buyer_type;
