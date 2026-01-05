
  create view "ecommerce_db"."analytics"."stg_sellers__dbt_tmp"
    
    
  as (
    /*
    Staging model for sellers table
    - Cleans and standardizes seller data
    - Foundation for marketplace seller analytics
*/

SELECT
    -- Primary key
    seller_id,
    
    -- Business columns
    seller_zip_code_prefix,
    seller_city,
    seller_state

FROM "ecommerce_db"."public"."sellers"
  );