with source as (

    select *
    from {{ source('raw', 'Categories') }}

),

renamed as (

    select

        cast(categoryid as number)                 as category_id,
        cast(categoryname as varchar)              as category_name,
        cast(department as varchar)                as department,
        cast(categorydescription as varchar)       as category_description,
        cast(isactive as boolean)                  as is_active,
        cast(createddate as date)                  as created_date

    from source

)

select * from renamed