with src_products as (
    SELECT * 
    FROM {{ ref ('base_sql_server__addresses')}}
),

normalized_prod as (
    SELECT
product_id,
TRIM(IFNULL(NAME, 'Unkown'), ' ') AS product_name,
IFNULL(PRICE,'0') AS unit_price_usd,
IFNULL(inventory, '0') AS inventory,
CONVERT_TIMEZONE('UTC', _fivetran_synced) as date_load
FROM src_products
)

SELECT * FROM normalized_prod