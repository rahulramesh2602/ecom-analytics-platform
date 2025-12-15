-- Preview Customer Analytics - Key Metrics Only
SELECT 
    customer_city,
    customer_state,
    total_lifetime_revenue,
    total_orders,
    ROUND(avg_order_value::NUMERIC, 2) AS avg_order_value,
    favorite_category,
    is_repeat_customer,
    first_order_date::DATE,
    last_order_date::DATE
FROM analytics.mart_customer_analytics 
ORDER BY total_lifetime_revenue DESC
LIMIT 10;
