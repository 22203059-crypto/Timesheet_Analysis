SELECT 
    posting_id,
    CAST(REPLACE(invoice_id,'INV','') AS INT) AS invoice_id,
    ledger_account,
    debit_amount,
    credit_amount,
    posting_status
FROM {{ref('stg_sage_gl_postings')}}