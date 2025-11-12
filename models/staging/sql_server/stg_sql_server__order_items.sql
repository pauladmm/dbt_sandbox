with src_order_items as (
    select * from {{source("sql_server", 'order_items')}}
),
normalized as (
    select
    {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} as order_items_id,
    order_id,
    product_id,
    quantity as units,
    CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load
    from src_order_items

)

select * from normalized