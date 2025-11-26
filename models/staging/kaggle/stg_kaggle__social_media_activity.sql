with src_social_media_activity as (
    select * 
    from {{ref('base_kaggle__mental_health_and_social_media')}}
),
with_device as (
    select
        *,
        case social_media_platform
            when 'TikTok' then 
                case when uniform(0,1,random()) < 0.98 then 'mobile' else 'desktop' end
            when 'YouTube' then 
                case 
                    when uniform(0,1,random()) < 0.50 then 'mobile'
                    when uniform(0,1,random()) < 0.90 then 'desktop'
                    else 'smart_tv'
                end
            when 'LinkedIn' then 
                case when uniform(0,1,random()) < 0.60 then 'desktop' else 'mobile' end
            when 'Instagram' then 
                case when uniform(0,1,random()) < 0.90 then 'mobile' else 'desktop' end
            else
                case when uniform(0,1,random()) < 0.70 then 'mobile' else 'desktop' end
        end as device
    from src_social_media_activity
),
normalized as (
    select
    user_id,
    abs(mod(hash(user_id || '_' || device), 100000000)) as device_id,
    -- EVENT TYPE
    case 
        when social_media_platform = 'YouTube' then 
            case 
                when uniform(0,1,random()) < 0.60 then 'view'
                when uniform(0,1,random()) < 0.85 then 'like'
                else 'comment'
            end
        when social_media_platform = 'TikTok' then
            case
                when uniform(0,1,random()) < 0.65 then 'view'
                when uniform(0,1,random()) < 0.90 then 'like'
                else 'share'
            end
        else
            case
                when uniform(0,1,random()) < 0.60 then 'view'
                when uniform(0,1,random()) < 0.85 then 'like'
                when uniform(0,1,random()) < 0.95 then 'comment'
                else 'share'
            end
    end as event_type,

    -- CONTENT TOPIC
    case 
        when social_media_platform = 'LinkedIn' then 'business'
        when social_media_platform = 'YouTube' and uniform(0,1,random()) < 0.5 then 'education'
        when uniform(0,1,random()) < 0.30 then 'lifestyle'
        when uniform(0,1,random()) < 0.50 then 'tech'
        when uniform(0,1,random()) < 0.70 then 'education'
        when uniform(0,1,random()) < 0.85 then 'mental_health'
        else 'entertainment'
    end as content_topic,

    -- SESSION TIME SECONDS
    (
        -- por plataforma
        case social_media_platform
            when 'TikTok' then uniform(10, 80, random())
            when 'Instagram' then uniform(15, 90, random())
            when 'YouTube' then uniform(60, 600, random())
            when 'Twitter' then uniform(10, 60, random())
            when 'LinkedIn' then uniform(20, 120, random())
            else uniform(10, 100, random())
        end
        *
        -- factor segun event_type
        case
            when event_type = 'view' then 0.6
            when event_type = 'like' then 1.0
            when event_type = 'comment' then 1.4
            when event_type = 'share' then 1.8
            else 1.0
        end
        *
        -- factor segun device
        case
            when device = 'mobile' then 1.0
            when device = 'desktop' then 1.2
            when device = 'tablet' then 1.1
            when device = 'smart_tv' then 2.2
            else 1.0
        end
    )::integer as session_time_seconds,
    record_loaded_at

from with_device

)

select * from normalized