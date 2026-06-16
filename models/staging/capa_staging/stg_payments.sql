SELECT 
    payment_id,
    user_id,
    CASE
        WHEN amount IS NULL OR amount < 0
        THEN 0
        ELSE amount
    END amount,
    payment_date
FROM {{source('raw','payments_raw')}}