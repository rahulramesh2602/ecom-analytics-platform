
  create view "ecommerce_db"."analytics"."stg_products__dbt_tmp"
    
    
  as (
    /*
    Staging model for products table
    - Cleans and standardizes raw products data
*/

SELECT
    -- primary key
    product_id,
    -- business columns
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

FROM "ecommerce_db"."public"."products"
  );