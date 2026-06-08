WITH employee AS(
    SELECT *
    FROM {{ref('int_employee')}}
)
SELECT *
FROM employee