
    
    

with all_values as (

    select
        test_engagement_state as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_modeling`
    group by test_engagement_state

)

select *
from all_values
where value_field not in (
    'No Test','Test Started Only','Test Completed'
)


