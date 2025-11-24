with src_student_performance as (
    SELECT *
    FROM {{ref("stg_kaggle__student_performance")}}
),
base as (
    SELECT
        (abs(mod(hash(student_id), 12)) + 1) as subject_id,
        case (abs(mod(hash(student_id), 12)) + 1)
            when 1  then 'Mathematics'
            when 2  then 'Physics'
            when 3  then 'Chemistry'
            when 4  then 'Biology'
            when 5  then 'History'
            when 6  then 'Geography'
            when 7  then 'English Literature'
            when 8  then 'Computer Science'
            when 9  then 'Economics'
            when 10 then 'Philosophy'
            when 11 then 'Art'
            when 12 then 'Music'
        end as subject_name
    from src_student_performance
)

select * from base