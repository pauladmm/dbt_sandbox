with src_addresses as (
    select *
   FROM {{source("sql_server", 'addresses')}}
),
normalized as (
    select 
    address_id,
    address,
    zipcode,
    country,
    state,
    CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load
    from src_addresses
)

select * from normalized