WITH counts AS (
    SELECT 
        (SELECT COUNT(*) FROM {{ref("stg_sql_server__users")}}) AS cnt_ecommerce,
        (SELECT COUNT(*) FROM {{ref("base_kaggle__mental_health_and_social_media")}}) AS cnt_social,
        (SELECT COUNT(*) FROM {{ref("stg_kaggle__student_performance")}}) AS cnt_student
),

min_count AS (
    SELECT 
        LEAST(cnt_ecommerce, cnt_social, cnt_student) AS min_users
    FROM counts
),

ecom AS (
    SELECT
        user_id AS ecommerce_user_id,
        ROW_NUMBER() OVER (ORDER BY user_id) AS rn
    FROM {{ref("stg_sql_server__users")}}
    QUALIFY rn <= (SELECT min_users FROM min_count)
),

social AS (
    SELECT
        user_id AS social_user_id,
        ROW_NUMBER() OVER (ORDER BY user_id) AS rn
    FROM {{ref("base_kaggle__mental_health_and_social_media")}}
    QUALIFY rn <= (SELECT min_users FROM min_count)
),

student AS (
    SELECT
        student_id AS student_user_id,
        ROW_NUMBER() OVER (ORDER BY student_id) AS rn
    FROM {{ref("stg_kaggle__student_performance")}}
    QUALIFY rn <= (SELECT min_users FROM min_count)
),


unified AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['ecommerce_user_id', 'social_user_id', 'student_user_id']) }} AS user_bridge_id,
        e.ecommerce_user_id,
        s.social_user_id,
        st.student_user_id
    FROM ecom e
    JOIN social s USING (rn)
    JOIN student st USING (rn)
)

SELECT *
FROM unified