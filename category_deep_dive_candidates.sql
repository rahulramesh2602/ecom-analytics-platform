-- Deep dive category analysis: Find the most interesting business opportunities
-- Looking for categories with specific characteristics that warrant investigation

WITH category_analysis AS (
    SELECT 
        product_category_name_english,
        performance_tier,
        total_product_revenue,
        total_orders,
        unique_customers,
        avg_items_per_order,
        avg_product_price,
        revenue_rank,
        
        -- Calculate some interesting ratios
        ROUND((total_product_revenue / total_orders)::NUMERIC, 2) as revenue_per_order,
        ROUND((total_orders::NUMERIC / unique_customers)::NUMERIC, 2) as repeat_purchase_rate,
        
        -- Identify potential issues/opportunities
        CASE 
            WHEN avg_items_per_order < 1.2 AND performance_tier = 'Top Performer' 
            THEN 'High Revenue, Low Basket Size - Cross-sell opportunity'
            WHEN avg_product_price > 150 AND total_orders < 1000 
            THEN 'High Price, Low Volume - Premium product analysis opportunity'
            WHEN performance_tier = 'Average Performer' AND total_orders > 2000 
            THEN 'High Volume, Average Revenue - Pricing optimization opportunity'
            WHEN performance_tier IN ('Focus Area', 'Average Performer') AND avg_product_price < 50
            THEN 'Low Price, Low Performance - Product quality/marketing opportunity'
            WHEN (total_orders::NUMERIC / unique_customers) < 1.1 AND performance_tier IN ('Top Performer', 'Strong Performer')
            THEN 'High Revenue, Low Retention - Customer loyalty opportunity'
            ELSE 'Standard performance'
        END as business_opportunity
        
    FROM analytics.mart_product_performance
)

SELECT 
    revenue_rank,
    product_category_name_english,
    performance_tier,
    business_opportunity,
    total_product_revenue,
    total_orders,
    revenue_per_order,
    repeat_purchase_rate,
    avg_product_price
FROM category_analysis 
WHERE business_opportunity != 'Standard performance'
ORDER BY 
    CASE performance_tier 
        WHEN 'Top Performer' THEN 1 
        WHEN 'Strong Performer' THEN 2 
        WHEN 'Average Performer' THEN 3 
        ELSE 4 
    END,
    total_product_revenue DESC;
