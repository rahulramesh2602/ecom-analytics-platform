/*
    Intermediate model joining core business entities
    - Combines orders, order items, customers, products, sellers, and category translations
    - Creates wide analytical dataset at order line item grain
    - Foundation for business analytics and reporting
    - Includes calculated fields for business insights
*/

WITH order_base AS (
    SELECT
        -- Order information
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date
    FROM "ecommerce_db"."analytics"."stg_orders"
),

order_items_base AS (
    SELECT
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value
    FROM "ecommerce_db"."analytics"."stg_order_items"
),

customers_base AS (
    SELECT
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    FROM "ecommerce_db"."analytics"."stg_customers"
),

products_base AS (
    SELECT
        product_id,
        product_category_name,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    FROM "ecommerce_db"."analytics"."stg_products"
),

sellers_base AS (
    SELECT
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
    FROM "ecommerce_db"."analytics"."stg_sellers"
),

category_translation AS (
    SELECT
        product_category_name,
        product_category_name_english
    FROM "ecommerce_db"."analytics"."stg_product_category_name_translation"
)

SELECT
    -- Order identifiers
    oi.order_id,
    oi.order_item_id,
    
    -- Order details
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    
    -- Customer information
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    c.customer_zip_code_prefix,
    
    -- Product information
    oi.product_id,
    p.product_category_name,
    ct.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    p.product_photos_qty,
    
    -- Seller information
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    s.seller_zip_code_prefix AS seller_zip_code_prefix,
    
    -- Financial information
    oi.price,
    oi.freight_value,
    oi.shipping_limit_date,
    
    -- Calculated fields
    (oi.price + oi.freight_value) AS total_item_value,
    
    CASE 
        WHEN o.order_delivered_customer_date IS NOT NULL 
             AND o.order_purchase_timestamp IS NOT NULL
        THEN EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))
        ELSE NULL
    END AS delivery_days,
    
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN TRUE
        ELSE FALSE
    END AS is_late_delivery

FROM order_items_base oi
LEFT JOIN order_base o ON oi.order_id = o.order_id
LEFT JOIN customers_base c ON o.customer_id = c.customer_id
LEFT JOIN products_base p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
LEFT JOIN sellers_base s ON oi.seller_id = s.seller_id