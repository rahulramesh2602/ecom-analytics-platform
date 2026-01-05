-- Business questions we can answer with available data
-- Map specific analytical opportunities to business value

SELECT 
    product_category_name_english,
    total_orders,
    avg_product_price,
    performance_tier,
    
    -- Specific business questions we can answer
    CASE product_category_name_english
        WHEN 'health_beauty' THEN 
            'Q1: Why do customers buy only 1 item per order despite high revenue? 
             Q2: What product combinations drive higher basket values?
             Q3: How can we increase cross-sell rates?'
        
        WHEN 'watches_gifts' THEN 
            'Q1: What drives willingness to pay premium prices ($201 avg)?
             Q2: How does seasonality affect luxury purchases?
             Q3: What are optimal pricing strategies for gift categories?'
        
        WHEN 'electronics' THEN 
            'Q1: Why is avg price only $58 despite 2,550 orders?
             Q2: What product mix changes could increase revenue per order?
             Q3: How price-sensitive are electronics customers?'
        
        WHEN 'bed_bath_table' THEN 
            'Q1: How can the highest-volume category (#1 in orders) scale further?
             Q2: What drives repeat purchases in home goods?
             Q3: Regional demand patterns and expansion opportunities?'
        
        ELSE 'Standard performance analysis available'
    END as business_questions_available
    
FROM analytics.mart_product_performance
WHERE product_category_name_english IN ('health_beauty', 'watches_gifts', 'electronics', 'bed_bath_table')
   OR total_orders > 5000
ORDER BY total_orders DESC;
