/*
    Monthly Sales Summary Mart
    
    Business Purpose:
    - Track monthly revenue trends and growth
    - Monitor order volume patterns
    - Identify seasonal trends
    
    Grain: One row per month
    
    Key Metrics:
    - Total revenue
    - Order count
    - Average order value
    - Customer count
    - Growth rates
*/

{{ config(materialized='table') }}

WITH monthly_base AS (
    SELECT
        -- Time dimension
        DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
        
        -- Aggregated metrics
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS unique_customers,
        SUM(total_item_value) AS total_revenue,
        SUM(price) AS total_product_revenue,
        SUM(freight_value) AS total_shipping_revenue,
        
        -- Calculate averages
        AVG(total_item_value) AS avg_order_value,
        COUNT(*) AS total_order_items
        
    FROM {{ ref('int_orders_joined') }}
    WHERE order_purchase_timestamp IS NOT NULL
    GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
),

monthly_with_growth AS (
    SELECT 
        order_month,
        total_orders,
        unique_customers,
        total_revenue,
        total_product_revenue,
        total_shipping_revenue,
        avg_order_value,
        total_order_items,
        
        -- Calculate items per order
        ROUND(total_order_items::NUMERIC / total_orders, 2) AS avg_items_per_order,
        
        -- Calculate revenue per customer
        ROUND(total_revenue::NUMERIC / unique_customers, 2) AS revenue_per_customer,
        
        -- Month-over-month growth calculations
        LAG(total_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
        LAG(total_orders) OVER (ORDER BY order_month) AS prev_month_orders,
        
        -- Calculate growth rates
        CASE 
            WHEN LAG(total_revenue) OVER (ORDER BY order_month) IS NOT NULL 
            THEN ROUND(
                ((total_revenue - LAG(total_revenue) OVER (ORDER BY order_month))::NUMERIC / 
                 LAG(total_revenue) OVER (ORDER BY order_month)::NUMERIC) * 100, 2
            )
            ELSE NULL
        END AS revenue_growth_rate,
        
        CASE 
            WHEN LAG(total_orders) OVER (ORDER BY order_month) IS NOT NULL 
            THEN ROUND(
                ((total_orders - LAG(total_orders) OVER (ORDER BY order_month))::NUMERIC / 
                 LAG(total_orders) OVER (ORDER BY order_month)::NUMERIC) * 100, 2
            )
            ELSE NULL
        END AS order_growth_rate
        
    FROM monthly_base
)

SELECT 
    order_month,
    total_orders,
    unique_customers,
    total_revenue,
    total_product_revenue,
    total_shipping_revenue,
    avg_order_value,
    total_order_items,
    avg_items_per_order,
    revenue_per_customer,
    prev_month_revenue,
    prev_month_orders,
    revenue_growth_rate,
    order_growth_rate,
    
    -- Add business insights flags
    CASE 
        WHEN revenue_growth_rate > 10 THEN 'High Growth'
        WHEN revenue_growth_rate > 0 THEN 'Growing'
        WHEN revenue_growth_rate = 0 THEN 'Flat'
        WHEN revenue_growth_rate < 0 THEN 'Declining'
        ELSE 'No Prior Data'
    END AS growth_category

FROM monthly_with_growth
ORDER BY order_month
