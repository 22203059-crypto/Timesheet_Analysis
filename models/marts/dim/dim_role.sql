WITH role AS(
    SELECT *
    FROM {{ref('int_role')}}
)
SELECT *
FROM role