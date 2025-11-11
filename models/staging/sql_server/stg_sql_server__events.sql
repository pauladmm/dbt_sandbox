with src_events as (
    select * from {{source("sql_server", 'events')}}
),
normalized as (
    select 
        event_id,
        session_id,
        user_id,
        order_id,
        product_id,
        page_url,
        event_type,
        CONVERT_TIMEZONE('UTC', created_at) as created_at,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load
    from src_events
)

select * from normalized