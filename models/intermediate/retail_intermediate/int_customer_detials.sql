WITH customer AS(
    SELECT * 
    FROM {{ref('stg_customers')}}
),
orders AS(
    SELECT *
    FROM {{ref('stg_orders')}}
),
transactions AS(
    SELECT * 
    FROM {{ref('stg_transactions')}}
),
region as(
    SELECT *
    FROM {{ref('stg_regions')}}
),
customer_detials as (
    SELECT
    c.customer_id,
    c.customer_name,
    c.gender,
    c.city,
    r.region_name,
    COUNT(o.order_id) as total_orders,
    COUNT(
            CASE
                WHEN o.order_status != 'Cancelled'
                THEN o.order_id
            END
        ) AS sucessfull_orders,
    SUM(
            CASE
                WHEN o.order_status != 'Cancelled'
                THEN o.total_amount
                ELSE 0
            END
        ) AS total_amount_spent,
    AVG(
            CASE
                WHEN o.order_status != 'Cancelled'
                THEN o.total_amount
            END
        ) AS avg_order_value,
    COUNT(
            CASE
                WHEN t.payment_status = 'Success'
                then t.transaction_id
            END
         ) as successful_transactions,
    COUNT(
            CASE
                WHEN t.payment_status = 'Failed' 
                THEN t.transaction_id
            END
        ) AS failed_transactions,

        MIN(
            CASE
                WHEN o.order_status != 'Cancelled'
                THEN o.order_date
            END
        ) AS first_order_date,

        MAX(
            CASE
                WHEN o.order_status != 'Cancelled'
                THEN o.order_date
            END
        ) AS last_order_date

        FROM customer c
        LEFT JOIN orders o
        ON c.customer_id = o.customer_id

        LEFT JOIN transactions t
        ON o.order_id = t.order_id

        LEFT JOIN region r
        ON c.region_id = r.region_id

        GROUP BY
            c.customer_id,
            c.customer_name,
            c.gender,
            c.city,
            r.region_name   
)
SELECT *
FROM customer_detials