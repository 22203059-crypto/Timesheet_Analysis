with source as (

    select *
    from {{ source('raw', 'Products') }}

),

renamed as (

    select

        cast(productid as number)              as product_id,
        cast(productname as varchar)           as product_name,
        cast(categoryid as number)             as category_id,
        cast(stockquantity as number)          as stock_quantity,
        price

    from source

)

select * from renamed