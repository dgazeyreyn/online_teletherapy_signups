



select
    1
from `mind-diagnostics-414622`.`dbt_dreynolds`.`fact_tests`

where not(completed in (true, false))

