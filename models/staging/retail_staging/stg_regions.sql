with source as (

    select *
    from {{ source('raw', 'Regions') }}

),

renamed as (

    select

        cast(regionid as number)               as region_id,
        cast(regionname as varchar)            as region_name

    from source

)

select * from renamed