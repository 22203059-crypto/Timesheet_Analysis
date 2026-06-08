WITH products AS (

    SELECT *
    FROM {{ ref('stg_products') }}

),

categories AS (

    SELECT *
    FROM {{ ref('stg_categories') }}

)

SELECT

    p.product_id,
    p.product_name,
    p.price,
    p.stock_quantity,
    c.category_id,
    c.category_name,
    c.department

FROM products p

LEFT JOIN categories c
    ON p.category_id = c.category_id