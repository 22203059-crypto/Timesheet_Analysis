WITH employee AS(
    SELECT *
    FROM {{ref('dim_employee')}}
),
role AS(
    SELECT *
    FROM {{ref('dim_role')}}
),
project AS(
    SELECT *
    FROM {{ref('fact_project')}}
),
timesheet AS(
    SELECT *
    FROM {{ref('fact_timesheet')}}
),
final AS(
    SELECT *
    FROM {{ref('rpt_timesheet')}}
),
record AS(
    SELECT
    'Record Count Check' AS validation_name,
    (
        SELECT
            count(*) 
        FROM timesheet
    ) as source_value ,
    (
        SELECT
            count(*)
        FROM final
    ) as target_value
),
employee_count AS(
    SELECT
    'Employee Count Check' AS validation_name,
    (
        SELECT  
            COUNT(DISTINCT employee_id)
        FROM employee
    ) as source_value,
    (
        SELECT
            COUNT(DISTINCT employee_id)
        FROM final
    ) as target_value
),
project_count AS(
    SELECT
    'Project Count Check' AS validation_name,
    (
        SELECT  
            COUNT(DISTINCT project_id)
        FROM project
    ) as source_value,
    (
        SELECT
            COUNT(DISTINCT project_id)
        FROM final
    ) as target_value
),
hours_count AS(
    SELECT
    'Hours Worked Check' AS validation_name,
    (
        SELECT  
            SUM(hours_worked)
        FROM timesheet
    ) as source_value,
    (
        SELECT
            SUM(hours_worked)
        FROM final
    ) as target_value
),
labor_cost AS(
    SELECT
    'Labor Cost Check' AS validation_name,
    (
        SELECT  
            SUM(labor_cost)
        FROM timesheet
    ) as source_value,
    (
        SELECT
            SUM(labor_cost)
        FROM final
    ) as target_value
),
base AS(
    SELECT * FROM employee_count
    UNION ALL
    SELECT * FROM project_count
    UNION ALL
    SELECT * FROM hours_count
    UNION ALL
    SELECT * FROM labor_cost
)
SELECT 
    validation_name,
    source_value,
    target_value,
    CASE
        WHEN source_value = target_value
        THEN 'PASS'
        ELSE 'FAIL'
    END AS validation_status
FROM base