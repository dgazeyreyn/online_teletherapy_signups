



select
    1
from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_traffic_type`

where not(has_test in (true, false))

