
    
    

with dbt_test__target as (

  select visitor_key as unique_field
  from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_traffic_type`
  where visitor_key is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


