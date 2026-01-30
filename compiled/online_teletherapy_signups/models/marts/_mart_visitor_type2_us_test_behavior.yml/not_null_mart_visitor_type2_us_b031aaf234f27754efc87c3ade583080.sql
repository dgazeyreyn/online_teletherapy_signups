
    
    



select first_test_taken_at_utc
from (select * from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_test_behavior` where has_test = true) dbt_subquery
where first_test_taken_at_utc is null


