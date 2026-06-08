with source as (
    select * from {{source('raw','Transactions')}}
),
renamed as (
    SELECT
    cast(transactionid   as number )  as transaction_id,
    cast(orderid         as number)   as order_id,
    cast(transactiondate as date)     as transaction_date,
    cast(paymentmethod   as varchar)  as payment_method,
    cast(paymentstatus   as varchar)  as payment_status,
    transactionamount                 as transaction_amount

    from source
)
select * from renamed