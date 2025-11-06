SELECT
    ADDRESS_ID,
    IFNULL(ZIPCODE, 'Unkown') AS ZIPCODE,
    TRIM(COUNTRY,' ') AS COUNTRY,
    TRIM(ADDRESS,' ') AS ADDRESS,
    TRIM(STATE,' ') AS STATE    
FROM {{source("sql_server", 'addresses')}}