with source as (

    select *
    from {{ source('raw', 'Orders') }}

),

renamed as (

    select

        cast(orderid as number)                as order_id,
        cast(customerid as number)             as customer_id,
        to_date(orderdate, 'DD-MM-YYY')        as order_date,
        totalamount                            as total_amount,
        cast(orderstatus as varchar)           as order_status

    from source

)

select * from renamed