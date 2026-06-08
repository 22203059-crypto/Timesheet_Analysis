WITH orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

)

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    order_status

FROM orders
WHERE order_status != 'Cancelled'