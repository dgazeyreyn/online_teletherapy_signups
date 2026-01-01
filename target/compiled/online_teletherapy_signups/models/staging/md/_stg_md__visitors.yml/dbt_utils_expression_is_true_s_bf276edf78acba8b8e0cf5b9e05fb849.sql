



select
    1
from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_md__visitors`

where not(updated_at >= created_at)

