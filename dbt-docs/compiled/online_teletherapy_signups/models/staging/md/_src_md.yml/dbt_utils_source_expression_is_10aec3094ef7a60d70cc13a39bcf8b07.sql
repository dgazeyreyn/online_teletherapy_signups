



select
    1
from `mind-diagnostics-414622`.`md`.`log_tests`

where not(completed in (true, false))

