WITH timesheet AS(
    SELECT *
    FROM {{ref('int_timesheet')}}
)
SELECT *
FROM timesheet