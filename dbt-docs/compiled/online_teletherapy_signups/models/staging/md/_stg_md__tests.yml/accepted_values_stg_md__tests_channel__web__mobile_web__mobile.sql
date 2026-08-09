
    
    

with all_values as (

    select
        channel as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_md__tests`
    group by channel

)

select *
from all_values
where value_field not in (
    'web','mobile web','mobile'
)


