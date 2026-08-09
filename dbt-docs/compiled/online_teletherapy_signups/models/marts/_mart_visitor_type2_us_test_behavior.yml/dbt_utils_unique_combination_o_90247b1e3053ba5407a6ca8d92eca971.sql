





with validation_errors as (

    select
        visitor_key
    from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_test_behavior`
    group by visitor_key
    having count(*) > 1

)

select *
from validation_errors


