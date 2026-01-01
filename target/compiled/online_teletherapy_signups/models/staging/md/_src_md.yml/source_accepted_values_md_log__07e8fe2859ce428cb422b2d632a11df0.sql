
    
    

with all_values as (

    select
        channel as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`md`.`log_tests`
    group by channel

)

select *
from all_values
where value_field not in (
    'web','mobile web','mobile'
)


