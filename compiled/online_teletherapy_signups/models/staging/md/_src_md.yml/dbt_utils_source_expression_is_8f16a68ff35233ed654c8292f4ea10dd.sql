



select
    1
from `mind-diagnostics-414622`.`md`.`log_tests`

where not(updated_at >= created_at)

