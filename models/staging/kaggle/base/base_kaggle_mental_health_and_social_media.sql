with src_wellbeing_and_social_media as (
    SELECT *
    FROM {{source("kaggle","mental_health_and_social_media_balance")}}
),
base as (
    SELECT
      user_id,
      daily_screen_time_hours,
      sleep_quality,
      stress_level,
      days_without_social_media,
      exercise_frequency_week,
      social_media_platform,
      happiness_index
)

select * from base