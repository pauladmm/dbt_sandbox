{% snapshot users_check_snp%}

{{
    config(
        target_schema='snapshots',
        unique_key='user_id',
        strategy='check',
        check_cols=['address_id','name','email','phone_number']
    )
}}

SELECT
        user_id,
        address_id,
        name, 
        email,
        phone_number,
        created_at,
        updated_at,
        date_load
FROM {{ ref("stg_sql_server__users") }}

{% endsnapshot %}