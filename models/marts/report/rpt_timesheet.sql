WITH employee AS(
    SELECT *
    FROM {{ref('dim_employee')}}
),
project AS(
    SELECT *
    FROM {{ref('fact_project')}}
),
timesheet AS(
    SELECT *
    FROM {{ref('int_timesheet')}}
),
base AS(
    SELECT 
        t.timesheet_id,
        t.employee_id,
        t.employee_name,
        t.department,
        t.role_name,
        e.hourly_rate,
        t.project_id,
        t.project_name,
        p.client_name,
        p.project_type,
        t.timesheet_date,
        t.hours_worked,
        t.billable_hours,
        t.nonbillable_hours,
        t.labor_cost,
        p.billable_hours AS project_billable_hours,
        p.resource_count,
        p.total_cost AS project_total_cost,
        t.status,
        current_timestamp() AS update_at
    FROM timesheet t
    LEFT JOIN employee e
        ON t.employee_id = e.employee_id
    
    LEFT JOIN project p
        ON t.project_id = p.project_id

)
SELECT *
FROM base 