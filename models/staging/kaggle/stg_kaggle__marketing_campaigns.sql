with src_campaign as (
    select *
    from {{source("kaggle","marketing_campaigns")}}
),
staging as (
    select
        campaign_id,
        campaign_type,
        topic, 
        target,
        sent_at
    from src_campaign
)

select * from staging