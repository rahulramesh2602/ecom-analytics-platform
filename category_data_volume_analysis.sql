-- Category data volume analysis for deep dive selection
-- Identify categories with sufficient data for meaningful business analysis

SELECT 
    product_category_name_english,
    performance_tier,
    total_orders,
    unique_customers,
    ROUND(avg_product_price::NUMERIC, 2) as avg_price,
    ROUND((total_product_revenue / 1000)::NUMERIC, 0) as revenue_k,
    revenue_rank,
    
    -- Data volume assessment
    CASE 
        WHEN total_orders >= 3000 AND unique_customers >= 2000 
        THEN 'High Volume - Excellent for analysis'
        WHEN total_orders >= 1000 AND unique_customers >= 800
        THEN 'Medium Volume - Good for analysis'  
        WHEN total_orders >= 500 AND unique_customers >= 400
        THEN 'Low Volume - Limited analysis possible'
        ELSE 'Insufficient data'
    END as analysis_potential,
    
    -- Business problem identification
    CASE 
        WHEN avg_product_price > 150 AND total_orders < 2000 
        THEN 'Premium pricing strategy analysis'
        WHEN total_orders > 5000 AND performance_tier = 'Top Performer'
        THEN 'Market leader optimization analysis'
        WHEN performance_tier = 'Average Performer' AND total_orders > 2000
        THEN 'Performance improvement analysis'
        WHEN avg_product_price < 80 AND total_orders > 2000
        THEN 'Volume pricing optimization analysis'
        ELSE 'Standard performance analysis'
    END as business_question_focus
    
FROM analytics.mart_product_performance
WHERE total_orders >= 500  -- Only categories with meaningful data volume
ORDER BY total_orders DESC, total_product_revenue DESC
LIMIT 15;
