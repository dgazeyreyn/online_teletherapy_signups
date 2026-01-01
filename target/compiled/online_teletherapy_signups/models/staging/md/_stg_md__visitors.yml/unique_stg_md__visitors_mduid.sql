
    
    

with dbt_test__target as (

  select mduid as unique_field
  from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_md__visitors`
  where mduid is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


