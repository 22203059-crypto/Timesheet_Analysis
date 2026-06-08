WITH sage AS(
    SELECT * 
    FROM {{ref('stg_sage_transactions')}}
),
base AS(
    SELECT 
        transaction_id,
        order_id,
        transaction_date,
        (debit_amount + credit_amount) AS total_amount,
        debit_amount,
        credit_amount,
        net_amount,
        transaction_status,
        CASE
            WHEN LOWER(ledger_account) LIKE '%revenue%'
            THEN 'revenue'
            WHEN LOWER(ledger_account) LIKE '%refund%'
            THEN 'refund'
            WHEN LOWER(ledger_account) LIKE '%receivable%'
            THEN 'receivable'
        END AS finance_category,
        CASE 
            WHEN net_amount < 0 
            THEN 'Debit'

            WHEN net_amount > 0 
            THEN 'Credit'

            ELSE 'Balanced'
        END as posting_type,
        CASE
             WHEN transaction_status = 'Posted'
             THEN net_amount
             ELSE 0
        END AS received_amount,
        CASE
            WHEN transaction_status = 'Pending'
            THEN ABS(net_amount)
            ELSE 0
        END AS outstanding_amount,
        CASE
            WHEN transaction_status = 'Failed'
            THEN ABS(net_amount)
            ELSE 0
        END AS refund_amount
    FROM sage
)
SELECT *
FROM base