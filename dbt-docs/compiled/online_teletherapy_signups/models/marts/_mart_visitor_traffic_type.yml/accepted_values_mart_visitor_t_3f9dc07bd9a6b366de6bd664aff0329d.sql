
    
    

with all_values as (

    select
        traffic_type as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_traffic_type`
    group by traffic_type

)

select *
from all_values
where value_field not in (
    'type_1','type_2','unknown'
)


