SELECT
    posting_id,
    invoice_id,
    customer_id,
    invoice_amount,
    debit_amount,
    credit_amount,
    balance_amount,
    finance_category,
    posting_type,
    settlement_status
FROM {{ ref('int_sage_financials') }}