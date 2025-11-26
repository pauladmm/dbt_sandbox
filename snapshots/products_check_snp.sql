{% snapshot products_check_snp%}

{{
    config(
        target_schema='snapshots',
        unique_key='product_id',
        strategy='check',
        check_cols=['product_name','unit_price_usd','inventory']
    )
}}

SELECT
        product_id,
        product_name,
        unit_price_usd, 
        inventory,
        date_load
FROM {{ ref("stg_sql_server__products") }}

{% endsnapshot %}