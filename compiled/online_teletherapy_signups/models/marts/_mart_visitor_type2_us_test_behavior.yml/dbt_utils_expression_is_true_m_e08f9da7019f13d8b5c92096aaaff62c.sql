



select
    1
from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_test_behavior`

where not(tests_completed_count <= tests_taken_count)

