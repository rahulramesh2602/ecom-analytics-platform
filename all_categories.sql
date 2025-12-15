-- Check total number of product categories
SELECT COUNT(*) as total_categories
FROM analytics.mart_product_performance;

-- Show all categories with their rankings
SELECT 
    revenue_rank,
    product_category_name_english,
    total_product_revenue,
    performance_tier
FROM analytics.mart_product_performance 
ORDER BY revenue_rank;
