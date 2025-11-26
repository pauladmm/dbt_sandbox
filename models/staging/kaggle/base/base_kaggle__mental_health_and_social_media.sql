with src_wellbeing_and_social_media as (
    SELECT *
    FROM {{source("kaggle","MENTAL_HEATLH_AND_SOCIAL_MEDIA_BALANCE")}}
),
base as (
    SELECT
      user_id,
      "Daily_Screen_Time(hrs)" as daily_screen_time_hours,
      "Sleep_Quality(1-10)" as sleep_quality,
     "Stress_Level(1-10)" as stress_level,
      days_without_social_media,
      "Exercise_Frequency(week)" as exercise_frequency_week,
      social_media_platform,
      "Happiness_Index(1-10)" as happiness_index,
       CONVERT_TIMEZONE('UTC',CURRENT_TIMESTAMP()) AS record_loaded_at
    from src_wellbeing_and_social_media
)

select * from base