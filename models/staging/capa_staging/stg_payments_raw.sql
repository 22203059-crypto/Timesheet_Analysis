WITH source AS(
    SELECT *
    FROM {{source('raw','payment_source_raw')}}
)
SELECT * 
FROM source