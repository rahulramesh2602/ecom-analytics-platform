/*
    Customer analytics Summary Mart
    
    Business Purpose:
    - Track customer behavior and preferences
    - Monitor customer lifetime value (CLV)
    - Identify high-value customer segments

    Grain: One row per customer

    Key Metrics:
    - Total revenue
    - Order count
    - Average order value
    - Favourite product category
*/

{{ config(materialized='table') }}

WITH customer_first_info AS (
    SELECT DISTINCT
        customer_id,
        FIRST_VALUE(customer_city) OVER (
            PARTITION BY customer_id 
            ORDER BY order_purchase_timestamp
        ) AS customer_city,
        FIRST_VALUE(customer_state) OVER (
            PARTITION BY customer_id 
            ORDER BY order_purchase_timestamp  
        ) AS customer_state
    FROM {{ ref('int_orders_joined') }}
),

category_counts AS (
    SELECT 
        customer_id,
        product_category_name_english,
        COUNT(*) as category_purchase_count,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY COUNT(*) DESC
        ) as category_rank
    FROM {{ ref('int_orders_joined') }}
    GROUP BY customer_id, product_category_name_english
),

favorite_categories AS (
    SELECT 
        customer_id, 
        product_category_name_english AS favorite_category
    FROM category_counts
    WHERE category_rank = 1
)

SELECT
    base.customer_id,
    info.customer_city,
    info.customer_state,
    SUM(total_item_value) AS total_lifetime_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_item_value) / COUNT(DISTINCT order_id) AS avg_order_value,
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date,
    fav.favorite_category,
    CASE WHEN COUNT(DISTINCT order_id) > 1 THEN TRUE ELSE FALSE END AS is_repeat_customer

FROM {{ ref('int_orders_joined') }} base
LEFT JOIN customer_first_info info ON base.customer_id = info.customer_id
LEFT JOIN favorite_categories fav ON base.customer_id = fav.customer_id
GROUP BY base.customer_id, info.customer_city, info.customer_state, fav.favorite_category