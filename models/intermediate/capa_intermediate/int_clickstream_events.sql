WITH events AS(
    SELECT *
    FROM {{ref('stg_clickstream_events')}}
),

base3 AS(
    SELECT
        *,
        CASE 
            WHEN event_name = 'page_view' 
            THEN 'Landing'

            WHEN event_name = 'click_signup'
            THEN 'Signup'

            WHEN event_name = 'signup_complete'
            THEN 'Registration'

            WHEN event_name = 'onboarding_complete'
            THEN 'Activation'

            WHEN event_name IN ('create_project','invite_teammate')
            THEN 'Engagement'

            WHEN event_name = 'subscription_started'
            THEN 'Paid'

            ELSE 'Others'
        END AS funnel_stage
    FROM events
),
final AS(
    SELECT
        event_id,
        CAST(REPLACE(TRIM(user_id),'U','') AS INT) AS user_id,
        event_date,
        event_time,
        event_name,
        funnel_stage,
        CASE 
            WHEN funnel_stage = 'Paid'
            THEN 'Customer'
            ELSE 'Prospect'
        END AS user_status,
        page_url,
        button_id,
        device_type,
        utm_source
    FROM base3
)
SELECT * FROM final
