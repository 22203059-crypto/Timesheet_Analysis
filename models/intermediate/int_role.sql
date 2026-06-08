SELECT 
    r.role_id,
    r.role_name,
    r.hourly_rate,
    r.daily_rate,
    COUNT(e.role_name) AS employee_count
FROM {{ref('stg_role')}} r
LEFT JOIN {{ref('int_employee')}} e
    ON r.role_name = e.role_name
GROUP BY    
    r.role_id,
    r.role_name,
    r.hourly_rate,
    r.daily_rate