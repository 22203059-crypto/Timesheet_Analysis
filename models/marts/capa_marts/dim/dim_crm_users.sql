WITH users AS(
    SELECT *
    FROM {{ref('int_crm_users')}}
)
SELECT *
FROM users