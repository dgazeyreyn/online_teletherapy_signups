



select
    1
from `mind-diagnostics-414622`.`md`.`log_visitor`

where not(updated_at >= created_at)

