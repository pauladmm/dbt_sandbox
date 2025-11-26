with events as (
    select * from {{ ref('stg_sql_server__events') }}
)

select
    event_id,
    user_id,
    session_id,
    event_type,
    product_id,
    created_at,
    case
        when event_type = 'view_product' then 1
        when event_type = 'add_to_cart' then 2
        when event_type = 'checkout' then 3
        when event_type = 'purchase' then 4
    end as funnel_stage
from events