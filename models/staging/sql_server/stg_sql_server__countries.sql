with src_countries as (
    select *
    FROM {{ ref ('base_sql_server__addresses')}}
),
countries_extracted as (
    select distinct
    md5(country) as country_id,
    TRIM(COUNTRY,' ') as country_name
    from src_countries
)

select * from countries_extracted