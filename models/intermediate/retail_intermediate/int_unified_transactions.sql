WITH Trans1 AS(
    SELECT
        'Naveone' AS source_system,
        transaction_id,
        order_id,
        transaction_date,
        payment_status AS transaction_status,
        transaction_amount AS expected_amount,
        collected_revenue AS received_amount,
        pending_amount AS outstanding_amount,
        refund_amount AS refund_amount
    FROM {{ref('int_transaction_metrics')}}
),
Trans2 AS(
    SELECT 
        'Sage' AS source_system,
        transaction_id,
        order_id,
        transaction_date,
        transaction_status,
        total_amount AS expected_amount,
        received_amount AS received_amount,
        outstanding_amount,
        refund_amount AS refund_amount
    FROM {{ref('int_sage_transactions')}}
)

SELECT * FROM Trans1
UNION ALL
SELECT * FROM Trans2