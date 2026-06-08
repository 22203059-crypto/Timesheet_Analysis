WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

regions AS (

    SELECT *
    FROM {{ ref('stg_regions') }}

)

SELECT

    c.customer_id,
    c.customer_name,
    c.gender,
    c.age,
    c.city,
    r.region_name,
    c.join_date

FROM customers c

LEFT JOIN regions r
    ON c.region_id = r.region_id