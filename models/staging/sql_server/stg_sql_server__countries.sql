with src_countries as (
    select *
    from {{source("sql_server",'addresses')}}
),
countries_extracted as (
    select
    md5(country) as country_id,
    TRIM(COUNTRY,' ') as country_name
    from src_countries
)

select * from countries_extracted