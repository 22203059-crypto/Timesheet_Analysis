WITH project AS(
    SELECT * 
    FROM {{ref('stg_projects')}}
),
timesheet AS(
    SELECT *
    FROM {{ref('int_timesheet')}}
),
base AS(
    SELECT 
        p.project_id,
        p.project_name,
        p.client_name,
        p.project_type,
        SUM(t.billable_hours) AS billable_hours,
        COUNT(DISTINCT(t.employee_id)) AS resource_count,
        SUM(t.labor_cost) AS total_cost
    FROM project p
    LEFT JOIN timesheet t
        ON p.project_id = t.project_id
    GROUP BY 
        p.project_id,
        p.project_name,
        p.client_name,
        p.project_type
)
SELECT *
FROM base