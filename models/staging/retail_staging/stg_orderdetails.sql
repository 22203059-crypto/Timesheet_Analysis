with source as (

    select *
    from {{ source('raw', 'OrderDetails') }}

),

renamed as (

    select

        cast(orderdetailid as number)          as order_detail_id,
        cast(orderid as number)                as order_id,
        cast(productid as number)              as product_id,
        cast(quantity as number)               as quantity,
        unitprice                              as unit_price,
        totalprice                             as total_price

    from source

)

select * from renamed