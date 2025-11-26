select
    order_id,
    created_at,
    delivery_at
from {{ ref('fct_orders') }}
where delivery_at < created_at
