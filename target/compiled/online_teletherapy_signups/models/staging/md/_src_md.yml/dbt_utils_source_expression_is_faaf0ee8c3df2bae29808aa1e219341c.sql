



select
    1
from `mind-diagnostics-414622`.`md`.`log_tests`

where not(site_id in (0, 1, 2, 4))

