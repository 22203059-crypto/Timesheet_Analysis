WITH payments AS(
    SELECT *
    FROM {{ref('int_payments')}}
)
SELECT *
FROM payments