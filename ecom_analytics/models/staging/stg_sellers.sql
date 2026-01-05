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

FROM {{ source('raw_data', 'sellers') }}
