{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

with src_orders as (
    select *
    from {{ source('sql_server', 'orders') }}
    {% if is_incremental() %}
        where _fivetran_synced > (select max(date_load) from {{ this }})
    {% endif %}
),

deduped as (
    select *
    from (
        select
            *,
            row_number() over (partition by order_id order by _fivetran_synced desc) as rn
        from src_orders
    )
    where rn = 1
),

normalized as (
    select
        ORDER_ID,
        ADDRESS_ID,
        PROMO_ID,
        USER_ID,
        TRACKING_ID,
        coalesce(SHIPPING_SERVICE, 'Unknown') as SHIPPING_SERVICE,
        coalesce(SHIPPING_COST, 0) as SHIPPING_COST,
        coalesce(ORDER_COST, 0) as ORDER_COST,
        coalesce(ORDER_TOTAL, 0) as ORDER_TOTAL,
        convert_timezone('UTC', CREATED_AT) as CREATED_AT,
        convert_timezone('UTC', ESTIMATED_DELIVERY_AT) as ESTIMATED_AT,
        convert_timezone('UTC', DELIVERED_AT) as DELIVERY_AT,
        STATUS,
        convert_timezone('UTC', _fivetran_synced) as date_load
    from deduped
)

select * from normalized
