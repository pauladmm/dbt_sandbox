with src_orders as (
    select * 
    from {{ source('sql_server', 'orders')}}
),
normalized as (
    select
        ORDER_ID,
        ADDRESS_ID,
        PROMO_ID,
        USER_ID,
        TRACKING_ID,
        IFNULL(SHIPPING_SERVICE, 'Unkown') as SHIPPING_SERVICE,
        IFNULL(SHIPPING_COST, '0') as SHIPPING_COST,
        IFNULL(ORDER_COST,'0') AS ORDER_COST,
        IFNULL(ORDER_TOTAL,'0') AS ORDER_TOTAL,
        CONVERT_TIMEZONE('UTC', CREATED_AT) as CREATED_AT,
        CONVERT_TIMEZONE('UTC', ESTIMATED_AT) as ESTIMATED_AT,
        CONVERT_TIMEZONE('UTC', DELIVERY_AT) as DELIVERY_AT,
        STATUS,
        date_load
)

select * from normalized