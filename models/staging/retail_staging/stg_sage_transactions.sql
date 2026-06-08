SELECT
    CAST(
        REPLACE(sage_transaction_id ,'SAGE_TXN_','')
        AS INT )AS transaction_id,
     CAST(
        REPLACE(order_id ,'O1','')
        AS INT ) AS order_id,
    posting_date AS transaction_date,
    ledger_account,
    debit_amount,
    credit_amount,
    net_amount,
    transaction_status
FROM {{source('raw','sage_transactions_retail')}}