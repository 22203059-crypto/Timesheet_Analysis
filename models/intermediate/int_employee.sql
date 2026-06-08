WITH employee AS(
    SELECT *
    FROM {{ref('stg_employee')}}
),
role AS(
    SELECT *
    FROM {{ref('stg_role')}}
),
base AS(
    SELECT
        e.employee_id,
        e.employee_name,
        e.department,
        r.role_name,
        r.hourly_rate,
        e.updated_at
    FROM employee e
    LEFT JOIN role r
        ON e.role_id = r.role_id
)
SELECT *
FROM base