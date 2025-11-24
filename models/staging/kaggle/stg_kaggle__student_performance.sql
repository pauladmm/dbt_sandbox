with src_student_performance as (
    SELECT *
    FROM {{source("kaggle","student_performance")}}
),
base as (
    SELECT
        student_id,
        (abs(mod(hash(student_id), 12)) + 1) as subject_id,
        hours_studied,
        sleep_hours,
        attendance_percent,
        previous_scores,
        exam_score,
        case abs(mod(hash(student_id || 'term'), 3))
            when 0 then 'first'
            when 1 then 'second'
            when 2 then 'third'
        end as term
    from src_student_performance
)

select * from base