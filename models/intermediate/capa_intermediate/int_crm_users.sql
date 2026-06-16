WITH users AS(
    SELECT 
        user_id,
        email,
        date,
        company_size,
        CASE
            WHEN company_size IN ('startup','small')
            THEN 'SMB'
            WHEN company_size IN ('medium','enterprise')
            THEN 'Enterprise'
            ELSE 'others'
        END AS customer_segment,
        DATEDIFF(
            'DAY',
            date,
            CURRENT_DATE
        ) AS account_age_days,
        subscription_tier,
        country
    FROM {{ref('stg_crm_users')}}
),
base AS(
    SELECT *
    FROM users
)
SELECT * 
FROM base