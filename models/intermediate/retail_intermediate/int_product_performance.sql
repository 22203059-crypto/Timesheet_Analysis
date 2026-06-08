WITH orderdetails AS (

    SELECT *
    FROM {{ ref('stg_orderdetails') }}

),

orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

products AS (

    SELECT *
    FROM {{ ref('stg_products') }}

),

categories AS (

    SELECT *
    FROM {{ ref('stg_categories') }}

),

product_performance AS (

    SELECT

        od.product_id,
        p.product_name,
        c.category_id,
        c.category_name,
        c.department,

        COUNT(DISTINCT od.order_id) AS total_orders,

        SUM(
            CASE
                WHEN o.order_status != 'Cancelled'
                THEN od.quantity
                ELSE 0
            END
        ) AS total_quantity_sold,

        SUM(
            CASE
                WHEN o.order_status != 'Cancelled'
                THEN od.total_price
                ELSE 0
            END
        ) AS total_product_revenue,

        AVG(
            CASE
                WHEN o.order_status != 'Cancelled'
                THEN od.unit_price
            END
        ) AS avg_unit_price

    FROM orderdetails od

    LEFT JOIN orders o
        ON od.order_id = o.order_id

    LEFT JOIN products p
        ON od.product_id = p.product_id

    LEFT JOIN categories c
        ON p.category_id = c.category_id

    GROUP BY

        od.product_id,
        p.product_name,
        p.product_id,
        c.category_id,
        c.category_name,
        c.department

)

SELECT *
FROM product_performance