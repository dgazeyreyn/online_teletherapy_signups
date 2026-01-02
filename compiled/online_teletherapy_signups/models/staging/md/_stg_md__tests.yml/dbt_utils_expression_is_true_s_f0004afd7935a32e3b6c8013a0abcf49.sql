



select
    1
from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_md__tests`

where not(updated_at >= created_at)

