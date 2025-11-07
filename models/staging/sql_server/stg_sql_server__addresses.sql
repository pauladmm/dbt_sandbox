with src_addresses as (
    select *
    FROM {{ ref ('base_sql_server__addresses')}}
),
as normalized_addr (
SELECT
    ADDRESS_ID,
    md5(country) as country_id,
    md5(state) as state_id,
    md5(zipcode) as zipcode_id,
    TRIM(ADDRESS,' ') AS address,
    date_load

)
select * from normalized_addr
