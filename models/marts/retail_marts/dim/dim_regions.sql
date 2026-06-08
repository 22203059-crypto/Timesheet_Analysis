WITH regions AS (

    SELECT *
    FROM {{ ref('stg_regions') }}

)

SELECT

    region_id,
    region_name

FROM regions