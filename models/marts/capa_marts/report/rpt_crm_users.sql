WITH users AS(
    SELECT *
    FROM {{ref('dim_crm_users')}}
),
event_counts AS (

    SELECT
        user_id,

        COUNT(*) AS total_events,

        CASE
            WHEN COUNT_IF(user_status = 'Customer') > 0
            THEN 'Customer'
            ELSE 'Prospect'
        END AS user_status

    FROM {{ ref('fact_clickstream_events') }}

    GROUP BY user_id

),
latest_events AS(
    SELECT  
        user_id,
        event_date,
        funnel_stage,
        device_type,
        utm_source
    FROM {{ref('fact_clickstream_events')}}
    QUALIFY ROW_NUMBER() OVER(
            PARTITION BY user_id
            ORDER BY event_date DESC 
        ) = 1 
),
final_events AS(
    SELECT
        l.*,
        c.total_events,
        c.user_status
    FROM latest_events l
    LEFT JOIN event_counts c
        ON l.user_id = c.user_id
),

payments AS(
    SELECT *
    FROM {{ref('fact_payments')}}
),
base AS(
    SELECT 
        u.user_id,
        u.email,
        u.date AS registered_date,
        u.company_size,
        u.account_age_days,
        u.subscription_tier,
        e.user_status,
        u.country,
        e.total_events,
        e.event_date,
        e.device_type,
        e.utm_source,
        p.total_payments,
        p.total_amount,
        p.first_payment_date,
        p.last_payment_date
    FROM users u
    LEFT JOIN final_events e
        ON u.user_id = e.user_id
    LEFT JOIN payments p
        ON u.user_id = p.user_id
)
SELECT *
FROM base