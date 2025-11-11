with src_addresses as (
    select *
   FROM {{source("sql_server", 'addresses')}}
),
normalized as (
    select 
    address_id,
    zipcode,
    country,
    state,
    CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load
)

select * from normalized