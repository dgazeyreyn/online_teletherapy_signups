
    
    

with all_values as (

    select
        tests_completed_count_bucket as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_modeling`
    group by tests_completed_count_bucket

)

select *
from all_values
where value_field not in (
    '0','1','2+'
)


