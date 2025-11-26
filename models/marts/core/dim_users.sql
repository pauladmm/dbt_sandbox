with addresses_info as (
    select
        u.address_id,
        u.zipcode_id,
        u.country_id,
        u.state_id,
        u.address,
        z.zipcode AS address_zipcode,
        c.country_name AS country,
        s.state_name AS state
    from {{ref("stg_sql_server__addresses")}} u
    left join {{ref("stg_sql_server__zipcodes")}} z ON u.zipcode_id = z.zipcode_id
    left join {{ref("stg_sql_server__countries")}} c ON u.country_id = c.country_id
    left join {{ref("stg_sql_server__states")}} s ON u.state_id = s.state_id
),
ecommerce_users_info as (
    select
        u.user_id,
        u.name,
        u.email,
        u.phone_number,
        u.address_id,
        a.address,
        a.address_zipcode,
        a.country,
        a.state,
        u.created_at,
        u.updated_at
    from {{ref("stg_sql_server__users")}} u
    left join addresses_info a ON u.address_id = a.address_id
    
),
wellbeing as (
select *
    from {{ref("stg_kaggle__wellbeing")}}
),
sm_behaviour as (
    select *
    from {{ref("stg_kaggle__social_media_behaviour")}}
),
user_device as (
    select
        b.user_id,
        b.device_id,
        d.device
    from {{ref("stg_kaggle__social_media_activity")}} b
    LEFT JOIN {{ref("stg_kaggle__devices")}} d ON b.device_id = d.device_id
),
subjects as (
    select
    sp.student_id,
    LISTAGG(s.subject_name, ', ') WITHIN GROUP (ORDER BY s.subject_name) AS subjects
    from {{ref("stg_kaggle__student_performance")}} sp
    left join {{ref("stg_kaggle__subjects")}} s on s.subject_id = sp.subject_id
    GROUP BY sp.student_id
)


select
    {{ dbt_utils.generate_surrogate_key(['user_bridge_id', 'ecommerce_user_id', 'social_user_id','student_user_id']) }} as user_key,
    user_bridge_id,
    ecommerce_user_id,
    social_user_id,
    student_user_id,
    u.address_id,
    u.name,
    u.email,
    u.phone_number,
    u.address,
    u.state,
    u.country,
    u.address_zipcode,
    ud.device,
    smb.daily_screen_time_hours,
    smb.days_without_social_media,
    w.sleep_quality,
    w.stress_level,
    w.exercise_frequency_week,
    w.happiness_index,
    u.created_at,
    u.updated_at
from {{ref("stg__identity_bridge")}} ib
left join ecommerce_users_info u on u.user_id = ib.ecommerce_user_id
left join wellbeing w on w.user_id = ib.social_user_id 
left join sm_behaviour smb on smb.user_id = ib.social_user_id
left join user_device ud on ud.user_id = ib.social_user_id
left join subjects s on s.student_id = ib.student_user_id