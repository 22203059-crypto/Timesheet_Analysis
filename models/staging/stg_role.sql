WITH role AS(
    SELECT 
        roleid AS role_id,
        rolename AS role_name,
        hourlyrate AS hourly_rate,
        dailyrate AS daily_rate
    FROM {{source('raw','DimRole')}}
)
SELECT *
FROM role