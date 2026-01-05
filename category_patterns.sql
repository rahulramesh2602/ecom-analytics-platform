-- Additional analysis: Look for volume/price/performance patterns
SELECT 
    product_category_name_english,
    performance_tier,
    total_orders,
    unique_customers,
    avg_product_price,
    ROUND((total_product_revenue / 1000)::NUMERIC, 0) as revenue_k,
    ROUND((total_orders::NUMERIC / unique_customers)::NUMERIC, 2) as orders_per_customer,
    
    -- Identify interesting patterns
    CASE 
        WHEN avg_product_price > 180 THEN 'Premium Category'
        WHEN total_orders > 8000 THEN 'High Volume Category' 
        WHEN unique_customers > 7000 THEN 'Broad Appeal Category'
        WHEN avg_product_price < 60 AND performance_tier = 'Average Performer' THEN 'Low-Price Underperformer'
        ELSE 'Standard Category'
    END as category_profile
    
FROM analytics.mart_product_performance
WHERE performance_tier IN ('Top Performer', 'Strong Performer', 'Average Performer')
ORDER BY total_product_revenue DESC
LIMIT 15;
