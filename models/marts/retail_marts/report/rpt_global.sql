WITH global_fact AS (
    SELECT *
    FROM {{ ref('fact_global') }}
),

customers AS (
    SELECT *
    FROM {{ ref('dim_customers') }}
),


final AS (
    SELECT
        g.source_system,
        g.customer_id,
        c.customer_name,
        c.city,
        g.document_id,
        g.transaction_date,
        g.expected_amount,
        g.received_amount,
        g.outstanding_amount,
        g.refund_amount,
        g.due_days,
        g.aging_bucket,
        current_timestamp() as updated_at
    FROM global_fact g
    LEFT JOIN customers c
        ON g.customer_id = c.customer_id
)

SELECT *
FROM final