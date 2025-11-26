with base as (
    select
        user_id,
        product_id,
        funnel_stage,
        created_at,
        session_id
    from {{ ref('fct_events') }}
),

stage_per_user as (
    select
        user_id,
        product_id,
        min(case when funnel_stage = 1 then created_at end) as first_view,
        min(case when funnel_stage = 2 then created_at end) as first_add_to_cart,
        min(case when funnel_stage = 3 then created_at end) as first_checkout,
        min(case when funnel_stage = 4 then created_at end) as first_purchase
    from base
    group by 1, 2
),

flags as (
    select
        *,
        case when first_view is not null then 1 else 0 end as viewed,
        case when first_add_to_cart is not null then 1 else 0 end as added_to_cart,
        case when first_checkout is not null then 1 else 0 end as checkout_started,
        case when first_purchase is not null then 1 else 0 end as purchased
    from stage_per_user
),

aggregated as (
    select
        product_id,
        count_if(viewed = 1) as views,
        count_if(added_to_cart = 1) as add_to_cart,
        count_if(checkout_started = 1) as checkout,
        count_if(purchased = 1) as purchases
    from flags
    group by 1
),
products as (
    select
    product_id,
    product_name
    from {{ ref('dim_products') }}
)

select
    a.product_id,
    p.product_name,
    a.views,
    a.add_to_cart,
    a.checkout,
    a.purchases,
    round(a.add_to_cart::float / nullif(a.views, 0), 4) as view_to_cart_rate,
    round(a.checkout::float / nullif(a.add_to_cart, 0), 4) as cart_to_checkout_rate,
    round(a.purchases::float / nullif(a.checkout, 0), 4) as checkout_to_purchase_rate,
    round(a.purchases::float / nullif(a.views, 0), 4) as view_to_purchase_rate
from aggregated a
left join products p
    on a.product_id = p.product_id
order by views desc
