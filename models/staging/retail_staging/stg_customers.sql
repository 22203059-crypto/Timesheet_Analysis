with source as (

    select *
    from {{ source('raw', 'Customers') }}

),

renamed as (

    select

        cast(customerid as number)             as customer_id,
        cast(customername as varchar)          as customer_name,
        cast(email as varchar)                 as email,
        cast(gender as varchar)                as gender,
        cast(age as number)                    as age,
        cast(city as varchar)                  as city,
        cast(regionid as number)               as region_id,
        cast(joindate as date)                 as join_date

    from source

)

select * from renamed