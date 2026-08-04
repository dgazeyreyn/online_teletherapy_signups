
    
    

with child as (
    select visitor_key as from_field
    from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_modeling`
    where visitor_key is not null
),

parent as (
    select visitor_key as to_field
    from `mind-diagnostics-414622`.`dbt_dreynolds`.`dim_visitors`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


