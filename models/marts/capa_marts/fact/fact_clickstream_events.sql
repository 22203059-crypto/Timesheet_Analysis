WITH events AS(
    SELECT *
    FROM {{ref('int_clickstream_events')}}
)
SELECT *
FROM events