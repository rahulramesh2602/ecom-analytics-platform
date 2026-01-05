
  create view "ecommerce_db"."analytics"."stg_product_category_name_translation__dbt_tmp"
    
    
  as (
    /*
    Staging model for product category name translation table
    - Cleans and standardizes category translation data
    - Maps Portuguese category names to English equivalents
*/

SELECT
    -- Translation columns
    product_category_name,
    product_category_name_english

FROM "ecommerce_db"."public"."product_category_name_translation"
  );