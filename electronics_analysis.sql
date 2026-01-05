-- Electronics category analysis
-- Let's see what opportunities exist in electronics-related categories

SELECT 
    product_category_name_english,
    performance_tier,
    total_orders,
    unique_customers,
    ROUND(avg_product_price::NUMERIC, 2) as avg_price,
    ROUND((total_product_revenue / 1000)::NUMERIC, 0) as revenue_k,
    ROUND((total_orders::NUMERIC / unique_customers)::NUMERIC, 2) as orders_per_customer,
    revenue_rank,
    
    -- Identify the specific opportunity
    CASE 
        WHEN avg_product_price > 150 AND total_orders < 2000 
        THEN 'High Price, Low Volume - Premium electronics analysis'
        WHEN performance_tier = 'Average Performer' AND total_orders > 1500
        THEN 'High Volume, Average Revenue - Pricing optimization'
        WHEN avg_product_price < 100 AND performance_tier = 'Average Performer'
        THEN 'Budget electronics - Quality/reliability analysis'
        WHEN total_orders > 3000 
        THEN 'High volume electronics - Market leader analysis'
        ELSE 'Standard electronics performance'
    END as electronics_opportunity
    
FROM analytics.mart_product_performance
WHERE product_category_name_english ILIKE '%electronic%' 
   OR product_category_name_english ILIKE '%computer%'
   OR product_category_name_english ILIKE '%audio%'
   OR product_category_name_english ILIKE '%telephony%'
   OR product_category_name_english ILIKE '%console%'
   OR product_category_name_english ILIKE '%small_appliance%'
ORDER BY total_product_revenue DESC;
