with devices as (
    select *
    from {{ref("stg_kaggle__devices")}}
),
device_user as (
    select
        user_id,
        device_id
    from {{ref("stg_kaggle__social_media_activity")}}
)

select
    {{ dbt_utils.generate_surrogate_key(['d.device_id', 'user_id']) }} as device_key,
    d.device_id,
    du.user_id,
    d.device
from devices d
left join device_user du on d.device_id = du.device_id