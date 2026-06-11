WITH customer AS(
    SELECT *
    FROM {{ref('dim_sage_customers')}}
),
financials AS(
    SELECT *
    FROM {{ref('fact_sage_financials')}}
),
invoices AS(
    SELECT *
    FROM {{ref('fact_sage_invoices')}}
),
navone AS(
    SELECT 
        customer_id,
        customer_name
    FROM {{ref('dim_customers')}}
),
base AS(
    SELECT
        c.customer_id,
        coalesce(n.customer_name,'no_name') as customer_name,
        c.country,
        c.customer_segment,
        f.invoice_id,
        f.invoice_amount,
        f.credit_amount,
        f.debit_amount,
        f.balance_amount,
        f.finance_category,
        f.posting_type,
        f.settlement_status,
        i.invoice_date,
        i.invoice_status,
        i.invoice_category,
        DATEDIFF( day,i.invoice_date,CURRENT_DATE) AS due_days,
        CASE 
            WHEN i.invoice_status IN ('Failed','Pending')
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
            WHEN i.invoice_status = 'Posted' AND (i.invoice_amount - f.credit_amount) > 0
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
    FROM customer c
    LEFT JOIN financials f
        ON c.customer_id = f.customer_id

    LEFT JOIN invoices i
        ON f.invoice_id = i.invoice_id

    LEFT JOIN navone n
        ON c.customer_id = n.customer_id

)
SELECT *
FROM base