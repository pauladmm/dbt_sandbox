with products as (
    select
    *
    from {{ref("stg_sql_server__products")}}
)

select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    product_id,
    product_name,
    unit_price_usd,
    inventory
from products