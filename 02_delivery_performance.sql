

SELECT 
	buyer_type, 
	ROUND(AVG(actual_days), 1) AS avg_actual_days, 
	ROUND(AVG(promised_days), 1) AS avg_promised_days, 
	ROUND(AVG(delivery_delta), 1) AS avg_delivery_delta 
FROM (
	SELECT 
		c.customer_unique_id, 
		CASE WHEN COUNT(o.order_id) = 1
			 THEN 'one_time'
			 ELSE 'repeat'
		END AS buyer_type, 
		   AVG(JULIANDAY(o.order_delivered_customer_date) - 
            JULIANDAY(o.order_purchase_timestamp)) AS actual_days,
        AVG(JULIANDAY(o.order_estimated_delivery_date) - 
            JULIANDAY(o.order_purchase_timestamp)) AS promised_days,
        AVG((JULIANDAY(o.order_delivered_customer_date) - 
             JULIANDAY(o.order_purchase_timestamp)) -
            (JULIANDAY(o.order_estimated_delivery_date) - 
             JULIANDAY(o.order_purchase_timestamp))) AS delivery_delta
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) delivery_table
GROUP BY buyer_type;




