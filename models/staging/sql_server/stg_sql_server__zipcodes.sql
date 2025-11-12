with src_zipcodes as (
    select *
    from {{ ref ('base_sql_server__addresses')}}
),
zipcodes_extracted as (
    select distinct
    md5(zipcode) as zipcode_id,
    IFNULL(ZIPCODE, 'Unkown') AS zipcode
    from src_zipcodes
)

select * from zipcodes_extracted