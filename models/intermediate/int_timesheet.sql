WITH employee AS(
    SELECT *
    FROM {{ref('int_employee')}}
),
timesheet AS(
    SELECT *
    FROM {{ref('stg_timesheet')}}
),
base AS(
    SELECT 
        t.timesheet_id,
        e.employee_id,
        e.employee_name,
        e.department,
        e.role_name,
        t.project_id,
        p.project_name,
        t.date AS timesheet_date,
        t.hours_worked,
        t.billable_hours,
        t.nonbillable_hours,
        t.hours_worked * e.hourly_rate AS labor_cost,
        t.status
    FROM timesheet t
    LEFT JOIN employee e
        ON t.employee_id = e.employee_id
    
    LEFT JOIN {{ref('stg_projects')}} p
        ON t.project_id = p.project_id
)   
SELECT *
FROM base