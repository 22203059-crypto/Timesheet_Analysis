WITH users AS(
    SELECT 
        CAST(
            REPLACE(user_id,'U','')
            AS INT) AS user_id,
        email,
        signup_date,
        company_size,
        subscription_tier,
        country
    FROM {{source('raw','crm_users_raw')}}
),
base AS(
    SELECT
        CAST(
            REPLACE(user_id,'U','')
            AS INT) AS user_id,
        CASE
            WHEN email IS NULL
            THEN CONCAT('user',(CAST(user_id AS VARCHAR)),'@gmail.com')
            ELSE email
        END AS email,
        signup_date AS date,
        CASE    
            WHEN company_size IS NULL 
            THEN 'unknown'
            ELSE LOWER(TRIM(company_size))
        END AS company_size,
        CASE 
            WHEN subscription_tier IS NULL
            THEN 'unknown'
            ELSE LOWER(subscription_tier)
        END AS subscription_tier,
        coalesce ( LOWER(REPLACE(TRIM(country),'.','')),'unknown') as country
    FROM users
)
SELECT *
FROM base