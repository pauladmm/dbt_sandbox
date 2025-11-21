with src_student_performance as (
    SELECT *
    FROM {{source("kaggle","student_performance")}}
),
base as (
    SELECT
        student_id,
        hours_studied,
        sleep_hours,
        attendance_percent,
        previous_scores,
        exam_score
)

select * from base