with products as (
    select
    *
    from {{ref("stg_sql_server__products")}}
)

select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    product_id,
    product_name,
    unit_price_usd as cost,
    (unit_price_usd * 0.21)+unit_price_usd as base_price,
    base_price - cost as base_margin
from products