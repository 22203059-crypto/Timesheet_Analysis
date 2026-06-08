WITH customer AS(
    SELECT 
        *,
        CASE
            WHEN customer_type = 'Corporate'
            THEN 'Enterprise'
            WHEN customer_type = 'Wholesale'
            THEN 'Business'
            ELSE 'Retail'
        END AS customer_segment
    FROM {{ref('stg_sage_customers')}}
),
base AS(
    SELECT 
    CAST(REPLACE(customer_id,'C','')AS INT) as customer_id,
    customer_segment,
    country
    FROM customer
)
SELECT *
FROM base