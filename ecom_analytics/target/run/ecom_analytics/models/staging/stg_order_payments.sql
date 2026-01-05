
  create view "ecommerce_db"."analytics"."stg_order_payments__dbt_tmp"
    
    
  as (
    /*
    Staging model for order payments table
    - Cleans and standardizes payment method data
    - Foundation for financial analytics
*/

SELECT
    -- Foreign key
    order_id,
    
    -- Business columns
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value

FROM "ecommerce_db"."public"."order_payments"
  );