with src_shipping as (
    select *
    from {{ref('base_sql_server__orders')}}
),
normalized as (
    select
        md5(IFNULL(SHIPPING_SERVICE, 'Unkown')) as shipping_id,
        IFNULL(SHIPPING_SERVICE, 'Unkown') as shipping_service_name
    from src_shipping
)

select * from normalized