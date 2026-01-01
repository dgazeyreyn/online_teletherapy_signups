



select
    1
from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_outcomes`

where not(has_trial_conversion in (0, 1))

