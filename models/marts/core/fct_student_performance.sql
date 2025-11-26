with student_performance as (
    select
    student_id,
    subject_id,
    hours_studied,
    sleep_hours,
    attendance_percent,
    previous_scores,
    exam_score,
    term
    from {{ref("stg_kaggle__student_performance")}}
),
student_info as(
    select
    student_user_id,
    user_key
    from {{ref("dim_users")}}
),

dim_date as (
    select * from {{ref("dim_date")}}
)

select
    {{ dbt_utils.generate_surrogate_key(['user_key','date_key', 'subject_id']) }} as performance_key,
    user_key,
    dd.date_key,
    subject_id,
    hours_studied,
    sleep_hours,
    attendance_percent,
    previous_scores,
    exam_score,
    sp.term
 from student_performance sp
 left join student_info si on sp.student_id = si.student_user_id
 left join dim_date dd on dd.term = sp.term