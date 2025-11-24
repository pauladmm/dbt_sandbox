with src_social_media_behaviour as (
    select *
    from {{ref("base_kaggle__mental_health_and_social_media")}}
),

normalized as (
    select
        user_id,
        daily_screen_time_hours,
        days_without_social_media
    from src_social_media_behaviour
)

select * from normalized
