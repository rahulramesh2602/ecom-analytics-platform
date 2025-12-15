-- Bottom 10 performing categories by revenue
SELECT 
    revenue_rank,
    product_category_name_english,
    ROUND(total_product_revenue::NUMERIC, 2) as total_product_revenue,
    performance_tier
FROM analytics.mart_product_performance 
ORDER BY revenue_rank DESC 
LIMIT 10;
