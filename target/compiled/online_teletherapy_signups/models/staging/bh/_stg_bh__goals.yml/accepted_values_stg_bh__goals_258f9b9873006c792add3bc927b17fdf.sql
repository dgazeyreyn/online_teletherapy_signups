
    
    

with all_values as (

    select
        stat_affiliate_info2 as value_field,
        count(*) as n_records

    from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_bh__goals`
    group by stat_affiliate_info2

)

select *
from all_values
where value_field not in (
    'email','mobile_app','mobile_web','desktop_web'
)


