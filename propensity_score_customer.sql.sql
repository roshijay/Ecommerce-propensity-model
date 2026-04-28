SELECT
    propensity_score,
    COUNT(*) AS customers
FROM (
    SELECT
        customer_unique_id,
        avg_review_score,
        avg_delivery_delta,
        product_category_name,
        payment_type,
        avg_order_value,
        (CASE WHEN avg_review_score >= 4 THEN 1 ELSE 0 END +
         CASE WHEN avg_delivery_delta < 0 THEN 1 ELSE 0 END +
         CASE WHEN payment_type = 'voucher' THEN 1 ELSE 0 END +
         CASE WHEN product_category_name IN ('cama_mesa_banho',
              'moveis_decoracao', 'ferramentas_jardim') THEN 1 ELSE 0 END +
         CASE WHEN avg_order_value > 120.65 THEN 1 ELSE 0 END
        ) AS propensity_score
    FROM (
        SELECT
            c.customer_unique_id,
            AVG(r.review_score) AS avg_review_score,
            AVG((JULIANDAY(o.order_delivered_customer_date) -
                 JULIANDAY(o.order_purchase_timestamp)) -
                (JULIANDAY(o.order_estimated_delivery_date) -
                 JULIANDAY(o.order_purchase_timestamp))) AS avg_delivery_delta,
            p.product_category_name,
            op.payment_type,
            AVG(oi.price) AS avg_order_value
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        JOIN order_items oi ON o.order_id = oi.order_id
        JOIN products p ON oi.product_id = p.product_id
        JOIN order_payments op ON o.order_id = op.order_id
        JOIN order_reviews r ON o.order_id = r.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_unique_id, p.product_category_name, op.payment_type
    ) customer_signals
) score_table
GROUP BY propensity_score
ORDER BY propensity_score DESC;
