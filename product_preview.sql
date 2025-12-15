-- Preview Top Product Categories by Performance
SELECT 
    revenue_rank,
    product_category_name_english,
    total_product_revenue,
    total_orders,
    unique_customers,
    ROUND(avg_product_price::NUMERIC, 2) AS avg_product_price,
    performance_tier
FROM analytics.mart_product_performance 
ORDER BY revenue_rank
LIMIT 15;
