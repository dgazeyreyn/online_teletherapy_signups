
    
    



select last_completed_test_taken
from (select * from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_test_behavior` where has_completed_test = true) dbt_subquery
where last_completed_test_taken is null


