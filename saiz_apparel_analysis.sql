-- Fashion/Apparel categories analysis for SAIZ alignment
-- Focus on apparel return reduction and customer satisfaction opportunities

SELECT 
    product_category_name_english,
    performance_tier,
    total_orders,
    unique_customers,
    ROUND(avg_product_price::NUMERIC, 2) as avg_price,
    ROUND((total_product_revenue / 1000)::NUMERIC, 0) as revenue_k,
    revenue_rank,
    
    -- SAIZ-relevant metrics
    CASE 
        WHEN product_category_name_english ILIKE '%fashion%' 
        THEN 'Direct Apparel - Primary SAIZ target'
        WHEN product_category_name_english ILIKE '%bag%' 
          OR product_category_name_english ILIKE '%shoe%'
          OR product_category_name_english ILIKE '%luggage%'
        THEN 'Apparel Accessories - Secondary SAIZ target'  
        WHEN product_category_name_english ILIKE '%baby%' 
          AND avg_product_price < 100
        THEN 'Baby Apparel - Sizing/fit critical'
        ELSE 'Non-apparel category'
    END as saiz_relevance,
    
    -- Identify business opportunities for SAIZ clients
    CASE 
        WHEN avg_product_price > 100 AND performance_tier != 'Top Performer'
        THEN 'High-value items with performance issues - Return reduction opportunity'
        WHEN total_orders > 1000 AND avg_product_price < 50
        THEN 'High volume, low price - Sizing standardization opportunity'
        WHEN performance_tier = 'Focus Area'
        THEN 'Underperforming category - Customer satisfaction analysis needed'
        ELSE 'Standard performance'
    END as saiz_opportunity
    
FROM analytics.mart_product_performance
WHERE product_category_name_english ILIKE '%fashion%'
   OR product_category_name_english ILIKE '%bag%'
   OR product_category_name_english ILIKE '%shoe%'
   OR product_category_name_english ILIKE '%luggage%'
   OR product_category_name_english ILIKE '%baby%'
   OR product_category_name_english ILIKE '%sport%'
ORDER BY 
    CASE 
        WHEN product_category_name_english ILIKE '%fashion%' THEN 1
        WHEN product_category_name_english ILIKE '%bag%' OR product_category_name_english ILIKE '%shoe%' THEN 2
        ELSE 3
    END,
    total_product_revenue DESC;
