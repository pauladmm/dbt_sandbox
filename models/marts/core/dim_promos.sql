with promos as (
    select
    promo_id,
    promo_descr,
    dollar_discount,
    is_active
    from {{ref("stg_sql_server__promos")}}
)

select 
    {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_key,
    promo_id,
    promo_descr,
    dollar_discount,
    is_active
from promos