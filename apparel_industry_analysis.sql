-- Apparel industry data analysis
-- Check data volume and business opportunities in fashion/apparel categories

SELECT 
    product_category_name_english,
    performance_tier,
    total_orders,
    unique_customers,
    ROUND(avg_product_price::NUMERIC, 2) as avg_price,
    ROUND((total_product_revenue / 1000)::NUMERIC, 0) as revenue_k,
    revenue_rank,
    
    -- Data volume assessment for analysis potential
    CASE 
        WHEN total_orders >= 1000 AND unique_customers >= 800 
        THEN 'Sufficient for robust analysis'
        WHEN total_orders >= 500 AND unique_customers >= 400
        THEN 'Moderate data - limited analysis possible'  
        WHEN total_orders >= 100 AND unique_customers >= 80
        THEN 'Small dataset - basic analysis only'
        ELSE 'Insufficient data'
    END as analysis_feasibility,
    
    -- Identify apparel-specific business opportunities
    CASE 
        WHEN product_category_name_english ILIKE '%fashion%' AND avg_product_price > 50
        THEN 'Fashion pricing and fit analysis opportunity'
        WHEN product_category_name_english ILIKE '%bag%' OR product_category_name_english ILIKE '%luggage%'
        THEN 'Accessory cross-sell and seasonal analysis'
        WHEN product_category_name_english ILIKE '%shoe%'
        THEN 'Footwear sizing and return analysis'
        WHEN product_category_name_english ILIKE '%sport%' AND total_orders > 1000
        THEN 'Athletic wear performance and seasonality analysis'
        ELSE 'General apparel business analysis'
    END as apparel_opportunity
    
FROM analytics.mart_product_performance
WHERE product_category_name_english ILIKE '%fashion%'
   OR product_category_name_english ILIKE '%bag%'
   OR product_category_name_english ILIKE '%shoe%'
   OR product_category_name_english ILIKE '%luggage%'
   OR product_category_name_english ILIKE '%sport%'
   OR product_category_name_english ILIKE '%baby%'  -- Often apparel-related
ORDER BY total_orders DESC;
