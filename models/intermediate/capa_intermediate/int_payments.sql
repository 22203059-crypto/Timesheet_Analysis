WITH payments AS(
    SELECT 
        payment_id,
        CAST(REPLACE(TRIM(user_id),'U','') AS INT) AS user_id,
        amount,
        payment_date
    FROM {{ref('stg_payments')}}
),
users AS(
    SELECT *
    FROM {{ref('int_crm_users')}}
),
base AS(
    SELECT 
        u.user_id,
        u.company_size,
        u.customer_segment,
        COUNT(p.payment_id) as total_payments,
        COALESCE(SUM(p.amount),0) AS total_amount,
        COALESCE(MIN(p.payment_date),'1900-01-01') as first_payment_date,
        COALESCE(MAX(p.payment_date),'1900-01-01') AS last_payment_date
    FROM users u
    LEFT JOIN payments p
        ON u.user_id = p.user_id
    GROUP BY 
        u.user_id,
        u.company_size,
        u.customer_segment
)
SELECT *
FROM base