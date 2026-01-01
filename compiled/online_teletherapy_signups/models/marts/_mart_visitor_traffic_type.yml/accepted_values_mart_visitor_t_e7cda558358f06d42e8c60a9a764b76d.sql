
    
    

with all_values as (

    select
        traffic_type_label as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_traffic_type`
    group by traffic_type_label

)

select *
from all_values
where value_field not in (
    'Organic / Direct (No Test)','Paid or Organic (Test Taken)','Unknown Attribution'
)


