with
    outcomes as (

        select
            visitor_key,

            -- target variable
            has_signup,

            -- baseline descriptive attributes
            browser,
            os_name,
            region,

        from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_outcomes`

    ),

    tests as (

        select
            visitor_key,

            -- engagement flags
            has_test,
            has_completed_test,

            -- volume
            tests_taken_count,
            tests_completed_count,

            -- timing
            test_latency_bucket,

            -- content
            first_test_taken,
            first_completed_test_taken

        from `mind-diagnostics-414622`.`dbt_dreynolds`.`mart_visitor_type2_us_test_behavior`

    ),

    final as (

        select
            o.visitor_key,

            -- 🎯 target
            o.has_signup,

            -- --------------------
            -- BASELINE FEATURES
            -- --------------------
            o.browser,
            o.os_name,
            o.region,

            -- --------------------
            -- TEST ENGAGEMENT STATE (PRIMARY)
            -- --------------------
            case
                when t.has_completed_test
                then 'Test Completed'
                when t.has_test
                then 'Test Started Only'
                else 'No Test'
            end as test_engagement_state,

            -- --------------------
            -- TEST VOLUME (BUCKETED)
            -- --------------------
            case
                when t.tests_taken_count = 0 or t.tests_taken_count is null
                then '0'
                when t.tests_taken_count = 1
                then '1'
                when t.tests_taken_count between 2 and 3
                then '2–3'
                else '4+'
            end as tests_taken_count_bucket,

            case
                when t.tests_completed_count = 0 or t.tests_completed_count is null
                then '0'
                when t.tests_completed_count = 1
                then '1'
                else '2+'
            end as tests_completed_count_bucket,

            -- --------------------
            -- TEST TIMING
            -- --------------------
            t.test_latency_bucket,

            -- --------------------
            -- TEST CONTENT (EXPLORATORY)
            -- --------------------
            t.first_test_taken,
            t.first_completed_test_taken

        from outcomes o
        left join tests t on o.visitor_key = t.visitor_key

    )

select *
from final