/*
    Staging model for customers table
    - Cleans and standardizes customer data
*/

SELECT
    -- primary key
    customer_id,
    customer_unique_id,
    -- business columns
    customer_zip_code_prefix,
    customer_city,
    customer_state 

FROM "ecommerce_db"."public"."customers"