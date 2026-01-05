-- Product-level performance mart
-- One row per product_id with detailed product metrics
WITH product_metrics AS (
    SELECT 
        p.product_id,
        oj.product_category_name_english,
        p.product_name_lenght,
        p.product_description_lenght,
        p.product_photos_qty,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm,
        
        -- Order metrics
        COUNT(DISTINCT oj.order_id) as total_orders,
        COUNT(DISTINCT oj.customer_id) as unique_customers,
        COUNT(oj.order_item_id) as total_quantity_sold,
        
        -- Revenue metrics  
        SUM(oj.total_item_value) as total_product_revenue,
        AVG(oj.price) as average_selling_price,
        AVG(oj.total_item_value) as average_order_value,
        
        -- Delivery metrics
        AVG(oj.delivery_days) as average_delivery_days,
        COUNT(CASE WHEN oj.is_late_delivery THEN 1 END) * 100.0 / COUNT(oj.order_id) as late_delivery_percentage,
        
        -- Time analysis
        MIN(oj.order_purchase_timestamp) as first_order_date,
        MAX(oj.order_purchase_timestamp) as last_order_date,
        
        -- Customer behavior
        AVG(oj.total_item_value) as average_item_value
        
    FROM "ecommerce_db"."analytics"."stg_products" p
    LEFT JOIN "ecommerce_db"."analytics"."int_orders_joined" oj 
        ON p.product_id = oj.product_id
    GROUP BY 
        p.product_id,
        oj.product_category_name_english,
        p.product_name_lenght,
        p.product_description_lenght,
        p.product_photos_qty,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm
),

product_rankings AS (
    SELECT 
        *,
        -- Revenue rankings
        ROW_NUMBER() OVER (ORDER BY total_product_revenue DESC NULLS LAST) as revenue_rank,
        ROW_NUMBER() OVER (PARTITION BY product_category_name_english ORDER BY total_product_revenue DESC NULLS LAST) as category_revenue_rank,
        
        -- Volume rankings
        ROW_NUMBER() OVER (ORDER BY total_quantity_sold DESC NULLS LAST) as volume_rank,
        ROW_NUMBER() OVER (PARTITION BY product_category_name_english ORDER BY total_quantity_sold DESC NULLS LAST) as category_volume_rank,
        
        -- Performance tiers
        CASE 
            WHEN total_product_revenue >= 50000 THEN 'Star Product'
            WHEN total_product_revenue >= 10000 THEN 'Strong Performer'  
            WHEN total_product_revenue >= 1000 THEN 'Average Performer'
            WHEN total_product_revenue > 0 THEN 'Low Performer'
            ELSE 'No Sales'
        END as performance_tier
        
    FROM product_metrics
)

SELECT 
    product_id,
    product_category_name_english,
    
    -- Product attributes
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    
    -- Sales metrics
    total_orders,
    unique_customers,
    total_quantity_sold,
    
    -- Revenue metrics
    ROUND(total_product_revenue::NUMERIC, 2) as total_product_revenue,
    ROUND(average_selling_price::NUMERIC, 2) as average_selling_price,
    ROUND(average_order_value::NUMERIC, 2) as average_order_value,
    
    -- Delivery metrics
    ROUND(average_delivery_days::NUMERIC, 1) as average_delivery_days,
    ROUND(late_delivery_percentage::NUMERIC, 2) as late_delivery_percentage,
    
    -- Time metrics
    first_order_date,
    last_order_date,
    ROUND(average_item_value::NUMERIC, 2) as average_item_value,
    
    -- Rankings
    revenue_rank,
    category_revenue_rank,
    volume_rank,
    category_volume_rank,
    
    -- Performance tier
    performance_tier
    
FROM product_rankings
ORDER BY revenue_rank