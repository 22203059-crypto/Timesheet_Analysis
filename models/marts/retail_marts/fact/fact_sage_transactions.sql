WITH trans AS(
    SELECT *
    FROM {{ref('int_sage_transactions')}}
)
SELECT * 
FROM trans