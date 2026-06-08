SELECT
    invoice_id,
    customer_id,
    invoice_date,
    invoice_amount,
    invoice_status,
    invoice_category
FROM {{ ref('int_sage_invoices') }}