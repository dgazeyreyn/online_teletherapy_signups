
    
    

with all_values as (

    select
        device_type as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_md__visitors`
    group by device_type

)

select *
from all_values
where value_field not in (
    'mobile','wearable','console','smarttv','tablet'
)


