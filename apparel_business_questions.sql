-- Apparel industry business questions analysis
-- Map specific analytical opportunities to business value for fashion/apparel

SELECT 
    product_category_name_english,
    total_orders,
    ROUND(avg_product_price::NUMERIC, 2) as avg_price,
    performance_tier,
    
    -- Specific business questions we can answer for apparel industry
    CASE 
        WHEN product_category_name_english = 'sports_leisure' THEN 
            'Q1: What drives high performance in athletic wear ($988K revenue)?
             Q2: How does seasonality affect sports equipment vs. apparel sales?
             Q3: What are optimal pricing strategies for sports categories?
             Q4: Cross-sell opportunities between equipment and apparel?'
        
        WHEN product_category_name_english = 'baby' THEN 
            'Q1: What drives repeat purchases in baby products ($412K revenue)?
             Q2: How do sizing issues affect customer satisfaction?
             Q3: What products have highest return rates?
             Q4: Age-based purchasing patterns and lifecycle analysis?'
        
        WHEN product_category_name_english = 'fashion_bags_accessories' THEN 
            'Q1: Why underperforming despite 1,864 orders?
             Q2: Seasonal trends in fashion accessories?
             Q3: Price sensitivity in fashion accessories?
             Q4: Cross-sell with clothing categories?'
        
        WHEN product_category_name_english = 'luggage_accessories' THEN 
            'Q1: What drives moderate performance in travel accessories?
             Q2: Seasonal/travel patterns affecting sales?
             Q3: Price optimization opportunities?'
        
        ELSE 'Basic fashion category analysis available'
    END as business_questions_available,
    
    -- Analysis complexity level
    CASE 
        WHEN total_orders >= 2000 THEN 'Advanced analysis possible'
        WHEN total_orders >= 1000 THEN 'Comprehensive analysis possible'
        WHEN total_orders >= 500 THEN 'Moderate analysis possible'
        ELSE 'Basic analysis only'
    END as analysis_depth
    
FROM analytics.mart_product_performance
WHERE product_category_name_english IN ('sports_leisure', 'baby', 'fashion_bags_accessories', 'luggage_accessories')
   OR product_category_name_english ILIKE '%fashion%'
ORDER BY total_orders DESC;
