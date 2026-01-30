





with validation_errors as (

    select
        ip_address, mduid
    from `mind-diagnostics-414622`.`dbt_dreynolds`.`int_visitors_resolved`
    group by ip_address, mduid
    having count(*) > 1

)

select *
from validation_errors


