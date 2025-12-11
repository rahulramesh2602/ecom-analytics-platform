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

FROM {{ source('raw_data', 'order_payments') }}
