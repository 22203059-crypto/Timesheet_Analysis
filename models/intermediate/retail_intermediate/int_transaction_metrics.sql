WITH transactions AS (

    SELECT *
    FROM {{ ref('stg_transactions') }}

),

orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),
transaction_metrics AS (

    SELECT

        t.transaction_id,
        t.order_id,
        o.customer_id,
        c.customer_name,
        t.transaction_date,
        t.payment_method,
        t.payment_status,
        o.total_amount as order_amount,
        o.order_status,
        t.transaction_amount,

        CASE
            WHEN t.payment_status = 'Success'
            THEN t.transaction_amount
            ELSE 0
        END AS collected_revenue,
        CASE
            WHEN t.payment_status = 'Failed'
            THEN t.transaction_amount
            ELSE 0
        END AS failed_process_amount,
        CASE
            WHEN t.payment_status = 'Pending'
            THEN t.transaction_amount
            ELSE 0
        END AS pending_process_amount,
        CASE 
            WHEN o.order_status = 'Pending' AND t.payment_status ='Success'
            THEN t.transaction_amount 
            ELSE 0
        END AS advance_payment,
        CASE 
            WHEN t.payment_status IN ('Failed','Pending')
            THEN o.total_amount
            ELSE ABS(o.total_amount - t.transaction_amount) 
        END as pending_amount,
        CASE
            WHEN o.order_status = 'Cancelled' AND t.payment_status ='Success'
            THEN ABS(o.total_amount - t.transaction_amount) 
            ELSE 0
        END AS refund_amount,
        DATEDIFF( day,t.transaction_date,CURRENT_DATE) AS due_days,
        CASE 
            WHEN t.payment_status IN ('Failed','Pending')
            THEN
                CASE
                    WHEN due_days BETWEEN 0 AND 30
                    THEN '0-30 Days'
                    WHEN due_days BETWEEN 31 AND 60
                    THEN '31-60 Days'
                    WHEN due_days BETWEEN 61 AND 90
                    THEN '61-90 Days'
                    ELSE '90+ Days'
                END 
            WHEN o.order_status = 'Delivered' AND (o.total_amount - t.transaction_amount) > 0
            THEN
                CASE
                    WHEN due_days BETWEEN 0 AND 30
                    THEN '0-30 Days'
                    WHEN due_days BETWEEN 31 AND 60
                    THEN '31-60 Days'
                    WHEN due_days BETWEEN 61 AND 90
                    THEN '61-90 Days'
                    ELSE '90+ Days'
                END
            ELSE 'All Cleared'
                
        END as aging_bucket
        
    FROM transactions t

    LEFT JOIN orders o
        ON t.order_id = o.order_id

    LEFT JOIN customers c
        ON o.customer_id = c.customer_id

)

SELECT *
FROM transaction_metrics