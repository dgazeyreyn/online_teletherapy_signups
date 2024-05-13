with
    source as (select * from {{ source("mind_diagnostics", "log_tests") }}),

    tests as (select ip_address as tests_ip from source)

select *
from tests
