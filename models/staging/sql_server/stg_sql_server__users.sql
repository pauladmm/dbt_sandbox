with src_users as (
    select * from {{source("sql_server",'users')}}
),
normalized as (
    select
        user_id,
        address_id,
        concat(first_name, last_name) as name,
        email,
        phone_number,
        CONVERT_TIMEZONE('UTC', CREATED_AT) as created_at,
        CONVERT_TIMEZONE('UTC', updated_at) as updated_at,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load

)

select * from normalized