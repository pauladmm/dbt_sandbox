with src_states as (
    select *
    from {{source("sql_server",'addresses')}}
),
states_extracted as (
    select
    md5(state) as state_id,
    TRIM(STATE,' ') as state_name
    from src_states
)

select * from states_extracted