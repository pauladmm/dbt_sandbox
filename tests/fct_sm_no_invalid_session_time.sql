select
    sm_activity_key,
    user_key,
    session_time_seconds,
    event_type,
    record_loaded_at
from {{ ref('fct_social_media_activity') }}
where session_time_seconds <= 0
