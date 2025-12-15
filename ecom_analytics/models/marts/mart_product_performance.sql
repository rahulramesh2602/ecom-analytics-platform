/*
    Product Performance Mart (Category Level)
    
    Business Purpose:
    - Analyze product category performance and revenue contribution
    - Identify top-performing categories for strategic focus
    - Support product portfolio optimization decisions
    - Enable category-level business intelligence and reporting

    Grain: One row per product category

    Key Metrics:
    - Total revenue and order volume per category
    - Customer reach and market penetration
    - Average pricing and profitability insights
    - Performance rankings for strategic prioritization
*/

{{ config(materialized='table') }}

SELECT
    -- Category identification
    product_category_name_english,
    
    -- Volume metrics
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(*) AS total_items_sold,
    COUNT(DISTINCT customer_id) AS unique_customers,
    
    -- Financial metrics  
    SUM(price) AS total_product_revenue,
    AVG(price) AS avg_product_price,
    SUM(total_item_value) AS total_revenue_with_shipping,
    SUM(freight_value) AS total_shipping_revenue,
    
    -- Customer behavior metrics
    ROUND(SUM(total_item_value)::NUMERIC / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer,
    ROUND(COUNT(*)::NUMERIC / COUNT(DISTINCT order_id), 2) AS avg_items_per_order,
    
    -- Performance rankings
    ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) AS revenue_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT order_id) DESC) AS order_volume_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT customer_id) DESC) AS customer_reach_rank,
    
    -- Business insights
    CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) <= 5 THEN 'Top Performer'
        WHEN ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) <= 15 THEN 'Strong Performer' 
        WHEN ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) <= 30 THEN 'Average Performer'
        ELSE 'Focus Area'
    END AS performance_tier
    
FROM {{ ref('int_orders_joined') }}
WHERE product_category_name_english IS NOT NULL
GROUP BY product_category_name_english
ORDER BY total_product_revenue DESC
