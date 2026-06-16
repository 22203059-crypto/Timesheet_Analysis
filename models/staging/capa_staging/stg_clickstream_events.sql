SELECT
    event_id,
    user_id,
    event_name,
    TRY_TO_TIMESTAMP(event_timestamp) as event_at,
    coalesce(TO_DATE(TRY_TO_TIMESTAMP(event_timestamp)),DATE '1900-01-01') AS event_date,
    coalesce(TO_TIME(TRY_TO_TIMESTAMP(event_timestamp)),TIME '00:00:00') AS event_time,
    page_url,
    coalesce(button_id,'unknown') as button_id,
    LOWER(coalesce(device_type,'unknown')) as device_type,
    LOWER(coalesce(utm_source,'unknown')) as utm_source
FROM {{source('raw','clickstream_events_raw')}}