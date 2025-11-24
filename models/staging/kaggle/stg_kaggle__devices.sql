with src_devices as (
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
    from src_devices
),
devices as (
select
    abs(mod(hash(user_id || '_' || device), 100000000)) as device_id,
    device

    from with_device
)
select * from devices