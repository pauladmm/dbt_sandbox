WITH orders_agg AS (
    SELECT
        user_key,
        COUNT(*) AS total_orders,
        SUM(order_total) AS total_spent,
        AVG(order_total) AS avg_order_value
    FROM {{ ref('fct_orders') }}
    GROUP BY user_key
),

social_agg AS (
    SELECT
        user_key,
        COUNT(*) AS total_social_sessions,
        AVG(session_time_seconds) AS avg_session_time_seconds,
        SUM(session_time_seconds) AS total_session_time,
        COUNT(DISTINCT content_topic) AS distinct_topics_interacted
    FROM {{ ref('fct_social_media_activity') }}
    GROUP BY user_key
),

performance_agg AS (
    SELECT
        user_key,
        AVG(final_exam_score) AS avg_exam_score,
        AVG(attendance_rate) AS avg_attendance_rate,
        AVG(homework_completion_rate) AS avg_homework_completion_rate
    FROM {{ ref('fct_student_performance') }}
    GROUP BY user_key
),

-- Optional: create a normalized scoring for segmentation
scoring AS (
    SELECT
        user_key,

        -- Engagement score (0–100)
        (COALESCE(avg_session_time_seconds, 0) * 0.6 
        + COALESCE(total_social_sessions, 0) * 0.4) AS engagement_score_raw,

        -- Academic score (0–100)
        (COALESCE(avg_exam_score, 0) * 0.7 
        + COALESCE(avg_attendance_rate, 0) * 0.3) AS academic_score_raw

    FROM social_agg
    FULL JOIN performance_agg USING (user_key)
)

SELECT
    COALESCE(o.user_key, s.user_key, p.user_key) AS user_key,

    -- Orders
    o.total_orders,
    o.total_spent,
    o.avg_order_value,

    -- Social activity
    s.total_social_sessions,
    s.avg_session_time_seconds,
    s.total_session_time,
    s.distinct_topics_interacted,

    -- Student performance
    p.avg_exam_score,
    p.avg_attendance_rate,
    p.avg_homework_completion_rate,

    -- Scores
    sc.engagement_score_raw AS engagement_score,
    sc.academic_score_raw AS academic_score

FROM orders_agg o
FULL JOIN social_agg s USING (user_key)
FULL JOIN performance_agg p USING (user_key)
FULL JOIN scoring sc USING (user_key);
