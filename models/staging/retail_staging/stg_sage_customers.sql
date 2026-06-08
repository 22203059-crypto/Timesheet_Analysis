WITH customers AS(
    SELECT *
    FROM {{source('raw','sage_customers')}}
)
SELECT * 
FROM customers