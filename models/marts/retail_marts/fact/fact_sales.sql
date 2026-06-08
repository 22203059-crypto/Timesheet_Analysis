WITH product_sales AS (

    SELECT *
    FROM {{ ref('int_product_performance') }}

)

SELECT *

FROM product_sales