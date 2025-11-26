{% snapshot promos_check_snp%}

{{
    config(
        target_schema='snapshots',
        unique_key='promo_id',
        strategy='check',
        check_cols=['promo_descr','dollar_discount','is_active']
    )
}}

SELECT
        promo_id,
        promo_descr,
        dollar_discount, 
        is_active,
        date_load
FROM {{ ref("stg_sql_server__promos") }}

{% endsnapshot %}