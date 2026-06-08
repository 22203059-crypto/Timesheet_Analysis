WITH feedback AS(
    SELECT * 
    FROM {{ref('stg_ticket_feedback')}}
),
base AS(
    SELECT
        feedback_id,
        ticket_id,
        customer_rating,
        feedback_text,
        CASE
            WHEN customer_rating >=4
            THEN 'positive'
            WHEN customer_rating >=2
            THEN 'neutral'
            ELSE 'Negative'
        END AS sentiment,
        CASE
            WHEN customer_rating IN (1,2)
            THEN 'Low Rating'
            WHEN customer_rating IN(3,4)
            THEN 'Average Rating'
            ELSE 'High Rating'
        END AS rating_bucket,
        CASE 
            WHEN LOWER(feedback_text) LIKE '%unresolved%'
            THEN 'Escalated'
            ELSE 'Normal'
        END AS escalation_flag,
        CASE 
            WHEN LOWER(feedback_text) LIKE '%helpful%' OR LOWER(feedback_text) LIKE '%excellent%'
            THEN 'Appreciation'
            WHEN LOWER(feedback_text) LIKE '%delayed%'
            THEN 'Delay Complaint'
            ELSE 'General Feedback'            
        END AS feedback_category

    FROM feedback
)
SELECT * 
FROM base