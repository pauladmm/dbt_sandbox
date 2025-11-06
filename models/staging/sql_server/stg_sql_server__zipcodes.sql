with src_zipcodes as (
    select *
    from {{source("sql_server",'addresses')}}
),
zipcodes_extracted as (
    select
    md5(zipcode) as zipcode_id,
    IFNULL(ZIPCODE, 'Unkown') AS zipcode
    from src_zipcodes
)

select * from zipcodes_extracted