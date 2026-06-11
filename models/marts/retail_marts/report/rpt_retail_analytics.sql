WITH orders AS (
    SELECT *
    FROM {{ ref('fact_orders') }}
),
sales AS (
    SELECT *
    FROM {{ ref('fact_sales') }}
),
transactions AS (
    SELECT *
    FROM {{ ref('fact_unified_transactions') }}
),
customers AS (
    SELECT *
    FROM {{ ref('dim_customers') }}
),
products AS (
    SELECT *
    FROM {{ ref('dim_products') }}
),
categories AS (
    SELECT *
    FROM {{ ref('dim_categories') }}
),
regions AS (
    SELECT *
    FROM {{ ref('dim_regions') }}
),
orderdetails AS(
    SELECT *
    FROM {{ref('stg_orderdetails')}}
),
final AS (
    SELECT
        o.order_id,
        o.order_date,
        o.order_status,
        c.customer_id,
        c.customer_name,
        c.gender,
        c.city,
        c.region_name,
        p.product_id,
        p.product_name,
        cat.category_name,
        cat.department,
        t.source_system,
        t.transaction_status,
        t.expected_amount,
        t.received_amount,
        t.outstanding_amount,
        t.refund_amount,
        current_timestamp() as updated_at
    FROM orders o
    LEFT JOIN customers c
    ON o.customer_id = c.customer_id
    LEFT JOIN orderdetails od
    ON o.order_id = od.order_id
    LEFT JOIN products p
    ON od.product_id = p.product_id
    LEFT JOIN categories cat
    ON p.category_id = cat.category_id
    LEFT JOIN transactions t
    ON o.order_id = t.order_id

)

SELECT *
FROM final