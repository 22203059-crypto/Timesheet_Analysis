WITH project AS(
    SELECT 
        projectid AS project_id,
        projectname AS project_name,
        clientname AS client_name,
        projecttype AS project_type
    FROM {{source('raw','DimProject')}}
)
SELECT *
FROM project