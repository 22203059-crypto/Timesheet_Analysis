SELECT
    customer_id,
    country,
    customer_segment
FROM {{ ref('int_sage_customers') }}