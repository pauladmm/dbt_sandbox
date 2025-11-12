with src_promos as (
    select * from {{source("sql_server", 'promos')}}
),
normalized as (
    select 
        md5(promo_id) as promo_id,
        promo_id as promo_descr,
        discount as dollar_discount,
        CASE 
            when TRIM(STATUS) = 'inactive' THEN False
            else True
        end as is_active,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load
    from src_promos

    union all

    
    select 
        md5('Unkown') as promo_id,
        'No promo' as promo_descr,
        0 as dollar_discount,
        True as is_active,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load
    from src_promos
    

)

select * from normalized