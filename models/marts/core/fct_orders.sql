with order_info as (
    select
    order_id,
    address_id,
    promo_id,
    user_id,
    tracking_id,
    shipping_id,
    shipping_cost,
    order_cost,
    order_total,
    created_at,
    estimated_at,
    delivery_at,
    status
    from {{ref("stg_sql_server__orders")}}

),
user_info as (
    select
    user_key,
    user_bridge_id,
    ecommerce_user_id
    from {{ref("dim_users")}}
),
promos_info as (
    select
    promo_key,
    promo_id
    from {{ref("dim_promos")}}
)

select
{{ dbt_utils.generate_surrogate_key(['order_id', 'user_key', 'promo_key']) }} AS order_key,
user_key,
promo_key,
order_id,
order_cost,
order_total,
created_at,
estimated_at,
delivery_at,
DATEDIFF(day, created_at, delivery_at) AS delivery_time_days
from order_info o
left join user_info u on u.ecommerce_user_id = o.user_id
left join promos_info p on p.promo_id = o.promo_id
