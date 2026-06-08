WITH categories AS (

    SELECT *
    FROM {{ ref('stg_categories') }}

)

SELECT

    category_id,
    category_name,
    department,
    category_description,
    is_active

FROM categories