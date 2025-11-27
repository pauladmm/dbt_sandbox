with 
orders as (
    select
        user_key,
        sum(order_total) as total_spent_last_90d,
        count(*) as total_orders_last_90d
    from {{ ref('fct_orders') }}
    where created_at >= dateadd(day, -90, current_date)
    group by 1
),

social as (
    select
        user_key,
        count(*) as sessions_last_30d,
        avg(session_time_seconds) as avg_session_time_last_30d,
        sum(session_time_seconds) as total_session_time_last_30d
    from {{ ref('fct_social_media_activity') }}
    where record_loaded_at >= dateadd(day, -30, current_date)
    group by 1
),

performance as (
    select
        user_key,
        avg(exam_score) as avg_exam_score,
        avg(attendance_percent) as avg_attendance,
        case 
            when avg(exam_score) < 50 then 1 
            else 0 
        end as academic_risk_flag
    from {{ ref('fct_student_performance') }}
    group by 1
),

users as (
    select user_key from {{ ref('dim_users') }}
)

select
    u.user_key,

    coalesce(o.total_spent_last_90d, 0) as total_spent_last_90d,
    coalesce(o.total_orders_last_90d, 0) as total_orders_last_90d,

    coalesce(s.sessions_last_30d, 0) as sessions_last_30d,
    ROUND((coalesce(s.avg_session_time_last_30d, 0)),0) as avg_session_time_last_30d,
    coalesce(s.total_session_time_last_30d, 0) as total_session_time_last_30d,

    ROUND((coalesce(p.avg_exam_score, 0)),1) as avg_exam_score,
    ROUND((coalesce(p.avg_attendance, 0)),1) as avg_attendance,
    coalesce(p.academic_risk_flag, 0) as academic_risk_flag

from users u
left join orders o       on u.user_key = o.user_key
left join social s       on u.user_key = s.user_key
left join performance p  on u.user_key = p.user_key
