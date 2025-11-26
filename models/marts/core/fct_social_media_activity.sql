with social_media_user as (
    select
        user_key,
        social_user_id
    from {{ ref("dim_users") }}
),

devices as (
    select
        device_key,
        device_id,
        device
    from {{ ref("dim_devices") }}
),

sm_activity as (
    select
        user_id,
        device_id,
        event_type,
        content_topic,
        session_time_seconds,
        record_loaded_at
    from {{ ref("stg_kaggle__social_media_activity") }}
),

dim_date as (
    select *
    from {{ ref("dim_date") }}
)

select
    {{ dbt_utils.generate_surrogate_key(['d.device_id','sma.user_id','dd.date_key']) }} as sm_activity_key,
    smu.user_key,
    d.device_key,
    dd.date_key,
    event_type,
    content_topic,
    session_time_seconds,
    record_loaded_at
from sm_activity sma
left join social_media_user smu on smu.social_user_id = sma.user_id
left join devices d on d.device_id = sma.device_id
left join dim_date dd on dd.date_day = cast(sma.record_loaded_at as date)
