WITH ticket AS(
    SELECT * 
    FROM {{ref('stg_support_tickets')}} 
),
cleaned as(
    SELECT
        ticket_id,
        customer_id,
        agent_id,
        issue_type,
        priority,
        ticket_status,
        resolved_date,
        created_date,
        COALESCE(resolution_time_hours, 0) AS resolution_time_hours
    FROM ticket
),
base AS (    
     SELECT *,
        CASE
            WHEN resolved_date IS null 
            THEN DATEDIFF(day,created_date,TO_DATE('2025-09-30'))
            ELSE 0
        END AS ticket_aging
    FROM cleaned
),
transformation AS(
    SELECT 
        ticket_id,
        customer_id,
        agent_id,
        issue_type,
        priority,
        ticket_status,
        created_date,
        ticket_aging,
        resolution_time_hours,
        CASE
            WHEN ticket_status != 'Closed'
            THEN
                CASE
                    WHEN ticket_aging BETWEEN 0 AND 2
                    THEN '0-2days'
                    WHEN ticket_aging BETWEEN 3 AND 4
                    THEN '3-4days'
                    ELSE '+5days'
                END
            ELSE 'Ticket Closed'
        END AS aging_bucket,
        CASE 
            WHEN resolution_time_hours = 0
            THEN 'Not Resolved'
            WHEN priority = 'High' AND resolution_time_hours > 24
            THEN 'SLA-Breached'
            WHEN priority = 'Medium' AND resolution_time_hours > 48
            THEN 'SLA-Breached'
            WHEN priority = 'Low' AND resolution_time_hours > 72
            THEN 'SLA-Breached'
            ELSE 'within-SLA'
        END AS sla_status,
        CASE    
            WHEN ticket_status IN ('Pending','Open')
            THEN 'Not Resolved'
            ELSE 'Resolved'
        END AS resolution_status

    FROM base
)

SELECT * 
FROM transformation

