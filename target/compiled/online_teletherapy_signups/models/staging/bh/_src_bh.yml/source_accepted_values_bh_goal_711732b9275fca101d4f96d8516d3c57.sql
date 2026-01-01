
    
    

with all_values as (

    select
        stat_affiliate_info1 as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`md`.`goals`
    group by stat_affiliate_info1

)

select *
from all_values
where value_field not in (
    'fm','md','pm','rd'
)


