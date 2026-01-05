/*
    Staging model for order items table
    - Cleans and standardizes order line item data
    - Casts timestamp columns to proper types
    - Foundation for order-product-seller relationships
*/

SELECT
    -- Primary/Foreign keys
    order_id,
    order_item_id,
    product_id,
    seller_id,
    
    -- Business columns
    shipping_limit_date::timestamp AS shipping_limit_date,
    price,
    freight_value

FROM "ecommerce_db"."public"."order_items"