with oi as (
    select
        order_items_id,
        order_id,
        product_id,
        units

    from {{ ref('stg_sql_server__order_items') }}
),

orders as (
    select
        order_id,
        user_id,
        promo_id,
        order_total,
        shipping_cost,
        created_at
    from {{ ref('stg_sql_server__orders') }}
),

promos as (
    select
        promo_id,
        discount_amount
    from {{ ref('dim_promos') }}
),

products as (
    select
        product_id,
        product_name,
        cost as unit_cost,
        base_price as price_paid
    from {{ ref('dim_products') }}
),

order_totals as (
    select
        oi.order_id,
        sum(p.price_paid * oi.units) as order_amount
    from oi
    left join products p
        on p.product_id = oi.product_id
    group by oi.order_id
),

shipping_allocation as (
    select
        oi.order_items_id,
        oi.order_id,
        oi.product_id,
        oi.units,
        p.price_paid,
        ot.order_amount,
        o.shipping_cost,
        (p.price_paid * oi.units / ot.order_amount) * o.shipping_cost as allocated_shipping
    from oi
    join order_totals ot using(order_id)
    join orders o using(order_id)
    left join products p on p.product_id = oi.product_id
),

final_calc as (
    select
        s.order_id,
        s.order_items_id,
        s.product_id,
        s.units,
        ROUND(s.price_paid,1),

        p.unit_cost,
        ROUND(s.allocated_shipping,1),

        ROUND((coalesce(pr.discount_amount / nullif(s.order_amount, 0) * (s.price_paid * s.units), 0)),1) as allocated_discount,

        ROUND(((s.price_paid * s.units) -
            coalesce(pr.discount_amount / nullif(s.order_amount, 0) * (s.price_paid * s.units), 0)),1) as net_revenue,

        ROUND(((p.unit_cost * s.units) + s.allocated_shipping),1) as total_cost,

        ROUND((
            (s.price_paid * s.units)
            - coalesce(pr.discount_amount / nullif(s.order_amount, 0) * (s.price_paid * s.units), 0)
            - (p.unit_cost * s.units)
            - s.allocated_shipping
        ),1) as margin
    from shipping_allocation s
    join products p on s.product_id = p.product_id
    join orders o on s.order_id = o.order_id
    left join promos pr on o.promo_id = pr.promo_id
)

select
    f.*,
    d.product_name
from final_calc f
join products d using(product_id)
order by margin desc
