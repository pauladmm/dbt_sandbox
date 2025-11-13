with src_shipping as (
    select *
    from {{ref('base_sql_server__orders')}}
),
normalized as (
    select
        case 
            when shipping_service = ' ' then md5('Unkown')
            else md5(IFNULL(SHIPPING_SERVICE, 'Unkown'))
        end as shipping_id,
        case 
            when shipping_service = ' ' then 'Unkown'
            else IFNULL(SHIPPING_SERVICE, 'Unkown')
        end as shipping_service_name
    from src_shipping

)

select * from normalized