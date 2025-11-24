with src_wellbeing as (
    select *
    from {{ref('base_kaggle__mental_health_and_social_media')}}
),
normalized as (
    select
        user_id,
        sleep_quality,
        stress_level,
        exercise_frequency_week,
        happiness_index
    from src_wellbeing
)

select * from normalized