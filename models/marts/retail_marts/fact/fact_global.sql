WITH navone AS(
    SELECT
        customer_id,
        order_id AS document_id,
        transaction_date,
        order_amount AS expected_amount,
        collected_revenue AS received_amount,
        pending_amount AS outstanding_amount,
        refund_amount,
        due_days,
        aging_bucket,
        'Naveone' AS source_system
    FROM {{ref('fact_transactions')}}
),
sage AS(
    SELECT
        customer_id,
        invoice_id AS document_id,
        invoice_date AS transaction_date,
        invoice_amount AS expected_amount,
        credit_amount AS received_amount,
        balance_amount AS outstanding_amount,
        CASE
            WHEN finance_category = 'Refund' 
            THEN debit_amount
            ELSE 0
        END AS refund_amount,
        due_days,
        aging_bucket,
        'Sage' AS source_system
    FROM {{ref('fact_sage_unified')}}
),
final AS(
SELECT * from navone
UNION ALL
SELECT * FROM sage
)
SELECT * 
FROM final