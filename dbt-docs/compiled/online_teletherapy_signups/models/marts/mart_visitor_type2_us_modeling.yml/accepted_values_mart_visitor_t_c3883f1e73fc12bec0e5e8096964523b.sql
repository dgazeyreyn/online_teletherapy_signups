
    
    

with all_values as (

    select
        test_latency_bucket as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_modeling`
    group by test_latency_bucket

)

select *
from all_values
where value_field not in (
    'No Test','Test Before First Seen','Immediate','Within 1 Hour','Within 6 Hours','Within 24 Hours','After 24 Hours'
)


