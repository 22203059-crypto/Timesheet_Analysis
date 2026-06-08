WITH emoployee AS(
    SELECT 
        employeeid AS employee_id,
        employeename AS employee_name,
        department,
        roleid as role_id,
        current_timestamp() AS updated_at
    FROM {{source('raw','DimEmployee')}}
)
SELECT *
FROM emoployee