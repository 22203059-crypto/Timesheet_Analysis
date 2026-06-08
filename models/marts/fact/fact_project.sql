WITH project AS(
    SELECT *
    FROM {{ref('int_project')}}
)
SELECT *
FROM project