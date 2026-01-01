



select
    1
from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_md__tests`

where not(site_id in (0, 1, 2, 4))

