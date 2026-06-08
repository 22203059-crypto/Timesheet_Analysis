WITH gl AS(
    SELECT * 
    FROM {{ref('int_sage_gl_postings')}}
),
invoice_amount AS(
    SELECT 
        t.posting_id,
        CAST(REPLACE(t.invoice_id, 'INV','') AS INT)AS invoice_id,
        p.customer_id,
        t.ledger_account,
        p.invoice_amount,
        t.debit_amount,
        t.credit_amount,
        t.posting_status
    FROM gl t
    LEFT JOIN {{ref('int_sage_invoices')}} p
    ON t.invoice_id = p.invoice_id
),
base AS(
    SELECT 
        posting_id,
        invoice_id,
        customer_id,
        invoice_amount,
        posting_status,
        debit_amount,
        credit_amount,       
        invoice_amount - credit_amount AS balance_amount,

        CASE 
            WHEN ledger_account = 'Sales Revenue'
            THEN 'Sales'

            WHEN ledger_account = 'Receivables'
            THEN 'Receivables'

            WHEN ledger_account = 'Refunds'
            THEN 'Refund'
        END AS finance_category,

        CASE
            WHEN credit_amount > 0
            THEN 'Credit'
            WHEN debit_amount > 0
            THEN 'Debit'
        END AS posting_type,

        CASE 
            WHEN balance_amount = 0 
            THEN 'Settled'
            ELSE 'Outstanding'
        END AS settlement_status
    FROM invoice_amount
)
SELECT *
FROM base