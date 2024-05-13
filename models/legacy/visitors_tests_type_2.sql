with
    visitors_tests as (
        select log_visitors_bot_handling.*, log_tests.test_taken
        from mind-diagnostics-414622.dbt_dreynolds.log_visitors_bot_handling
        left join
            {{ source("mind_diagnostics", "log_tests") }}
            on log_visitors_bot_handling.visitors_ip = log_tests.ip_address
    ),
    type_2 as (
        select *
        from visitors_tests
        where
            visitors_tests.visitors_gclid_flag is true
            or (
                visitors_tests.visitors_gclid_flag is false
                and visitors_tests.test_taken is not null
            )
    )
    select * from type_2
