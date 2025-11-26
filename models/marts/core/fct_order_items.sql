with order_items as (
    select
    *
    from {{ ref('stg_sql_server__order_items') }}
),
products as (
    select
    *
    from {{ ref('dim_products') }}
)
select
    oi.order_items_id,
    oi.order_id,
    oi.product_id,
    oi.units,
    p.base_price as price_paid,
    p.cost as unit_cost,
    p.cost * oi.units as total_cost,
    (p.base_price * oi.units) - (p.cost * oi.units) as margin
from order_items oi
left join products p
    on oi.product_id = p.product_id
