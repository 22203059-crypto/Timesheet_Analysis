WITH agents AS(
    SELECT * 
    FROM {{ref('stg_support_agents')}}
),
tickets AS(
    SELECT *
    FROM {{ref('int_support_tickets')}}
),
feedback AS(
    SELECT 
        customer_rating,
        ticket_id
    FROM {{ref('stg_ticket_feedback')}}
),
base AS(
    SELECT 
        a.agent_id,
        a.agent_name,
        a.department,
        a.experience_level,
        COUNT(t.ticket_id) AS total_tiket,
        COUNT(
            CASE 
                WHEN resolution_status = 'Resolved'
                THEN 1
            END
        ) as resolved_ticket,
        AVG(t.resolution_time_hours) AS avg_resolution_time,
        ROUND(
            AVG(f.customer_rating),2 
        ) AS avg_customer_rating,
        COUNT(
            CASE 
                WHEN sla_status = 'SLA-Breached'
                THEN 1
            END
        ) as sla_breach_count
    FROM agents a
    LEFT JOIN tickets t
        ON a.agent_id = t.agent_id
    LEFT JOIN feedback f
        ON t.ticket_id = f.ticket_id

    GROUP BY
        a.agent_id,
        a.agent_name,
        a.department,
        a.experience_level

)
SELECT * 
FROM base