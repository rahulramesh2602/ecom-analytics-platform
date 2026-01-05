
  create view "ecommerce_db"."analytics"."stg_orders__dbt_tmp"
    
    
  as (
    /*
    Staging model for orders table
    - Cleans and standardizes raw orders data
    - Casts timestamp columns to proper timestamp type
    - One-to-one relationship with source orders table
    - Foundation for downstream intermediate models
*/

SELECT
    --primary key
    order_id,
    --foreign key
    customer_id,
    --business columns
    order_status,
    --timestamp columns 
    order_purchase_timestamp::timestamp AS order_purchase_timestamp,
    order_approved_at::timestamp AS order_approved_at,
    order_delivered_carrier_date::timestamp AS order_delivered_carrier_date,
    order_delivered_customer_date::timestamp AS order_delivered_customer_date,
    order_estimated_delivery_date::timestamp AS order_estimated_delivery_date

FROM "ecommerce_db"."public"."orders"
  );