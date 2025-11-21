with src_wellbeing as (
    select *
    from {{ref('base_kaggle_mental_health_and_social_media')}}
),
normalized as (
    select
        user_id,
        sleep_quality,
        stress_level,
        exercise_frecuency_week,
        happiness_index
)

select * from normalized