SELECT
PRODUCT_ID,
IFNULL(PRICE,'0') AS PRICE,
TRIM(IFNULL(NAME, 'Unkown'), ' ') AS NAME,
IFNULL(inventory, '0') AS INVENTORY
FROM {{source("sql_server",'PRODUCTS')}}