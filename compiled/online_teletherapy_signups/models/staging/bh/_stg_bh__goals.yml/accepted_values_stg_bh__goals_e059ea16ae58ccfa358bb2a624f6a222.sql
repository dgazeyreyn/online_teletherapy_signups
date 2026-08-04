
    
    

with all_values as (

    select
        goal_name as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_bh__goals`
    group by goal_name

)

select *
from all_values
where value_field not in (
    'User Signup','Trial Converted'
)


