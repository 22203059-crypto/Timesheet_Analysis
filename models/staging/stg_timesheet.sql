WITH timesheet AS(
    SELECT 
        timesheetid AS timesheet_id,
        employeeid AS employee_id,
        projectid AS project_id,
        date,
        hoursworked AS hours_worked,
        billablehours AS billable_hours,
        nonbillablehours AS nonbillable_hours,
        taskcategory,
        status
    FROM {{source('raw','FactTimesheet')}}
)
SELECT *
FROM timesheet