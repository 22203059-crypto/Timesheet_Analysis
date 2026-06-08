WITH invoices AS(
    SELECT * 
    FROM {{ref('stg_sage_invoices')}}
),
base AS(
    SELECT 
    CAST(REPLACE(invoice_id, 'INV','') AS INT)AS invoice_id,
    CAST(REPLACE(customer_id, 'C','') AS INT) AS customer_id,
    invoice_date,
    invoice_amount,
    invoice_status,
    CASE 
        WHEN invoice_amount > 4000
        THEN 'High'

        WHEN invoice_amount > 2000
        THEN 'Medium'

        ELSE 'Low'
    END AS invoice_category
    FROM invoices
)
SELECT *
FROM base