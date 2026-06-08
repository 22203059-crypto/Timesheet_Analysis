WITH invoices AS(
    SELECT *
    FROM {{source('raw','sage_invoices')}}
)
SELECT * 
FROM invoices