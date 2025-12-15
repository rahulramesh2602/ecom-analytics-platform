-- Comparison of our two product marts (Option C: Both)
-- Shows the difference between category-level and product-level analysis

-- Category-level mart summary
SELECT 
    'Category-level mart' as mart_type,
    COUNT(*) as total_rows,
    'One row per category' as granularity
FROM analytics.mart_product_performance

UNION ALL

-- Product-level mart summary  
SELECT 
    'Product-level mart' as mart_type,
    COUNT(*) as total_rows,
    'One row per product' as granularity
FROM analytics.mart_individual_products;
