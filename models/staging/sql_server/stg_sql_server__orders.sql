with src_orders as (
    select *
    FROM {{ref("base_sql_server__orders")}}
),

normalized_orders as (
    
    SELECT
        ORDER_ID,
        ADDRESS_ID,
        MD5(IFNULL(PROMO_ID, 'Unkown')) AS PROMO_ID,
        USER_ID,
        TRACKING_ID,
        md5(IFNULL(SHIPPING_SERVICE, 'Unkown')) as shipping_id,
        IFNULL(SHIPPING_COST, '0') as SHIPPING_COST,
        IFNULL(ORDER_COST,'0') AS ORDER_COST,
        IFNULL(ORDER_TOTAL,'0') AS ORDER_TOTAL,
        CONVERT_TIMEZONE('UTC', CREATED_AT) as CREATED_AT,
        CONVERT_TIMEZONE('UTC', ESTIMATED_AT) as ESTIMATED_AT,
        CONVERT_TIMEZONE('UTC', DELIVERY_AT) as DELIVERY_AT,
        STATUS
    FROM src_orders
)

select * from normalized_orders