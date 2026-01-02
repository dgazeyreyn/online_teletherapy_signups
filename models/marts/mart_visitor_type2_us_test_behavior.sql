with
    visitors as (

        select visitor_key, browser, os_name, region, first_seen_at_utc
        from {{ ref("mart_visitor_type2_us_outcomes") }}

    ),

    tests as (

        select visitor_key, test_taken, completed, duration, test_taken_at_utc
        from {{ ref("fact_tests") }}

    ),

    visitor_test_rollup as (

        select
            v.visitor_key,

            -- volume
            count(t.test_taken_at_utc) as tests_taken_count,
            countif(t.completed) as tests_completed_count,

            -- ordering-based descriptors
            array_agg(t.test_taken order by t.test_taken_at_utc asc limit 1)[
                offset(0)
            ] as first_test_taken,

            array_agg(t.test_taken order by t.test_taken_at_utc desc limit 1)[
                offset(0)
            ] as last_test_taken,

            array_agg(
                if(t.completed, t.test_taken, null)
                ignore nulls
                order by t.test_taken_at_utc asc
                limit 1
            )[offset(0)] as first_completed_test_taken,

            array_agg(
                if(t.completed, t.test_taken, null)
                ignore nulls
                order by t.test_taken_at_utc desc
                limit 1
            )[offset(0)] as last_completed_test_taken,

            -- timestamps
            min(t.test_taken_at_utc) as first_test_taken_at_utc,

            -- raw timing difference (can be negative)
            min(
                timestamp_diff(t.test_taken_at_utc, v.first_seen_at_utc, hour)
            ) as raw_hours_to_first_test

        from visitors v
        left join tests t on v.visitor_key = t.visitor_key

        group by v.visitor_key

    ),

    final as (

        select
            v.visitor_key,
            v.browser,
            v.os_name,
            v.region,
            v.first_seen_at_utc,

            -- test volume
            r.tests_taken_count,
            r.tests_completed_count,

            safe_divide(
                r.tests_completed_count, r.tests_taken_count
            ) as test_completion_rate,

            -- test descriptors
            r.first_test_taken,
            r.last_test_taken,
            r.first_completed_test_taken,
            r.last_completed_test_taken,

            r.first_test_taken_at_utc,

            -- cleaned latency
            case
                when r.raw_hours_to_first_test < 0
                then null
                else r.raw_hours_to_first_test
            end as hours_to_first_test,

            -- latency buckets
            case
                when r.raw_hours_to_first_test is null
                then 'No Test'
                when r.raw_hours_to_first_test < 0
                then 'Test Before First Seen'
                when r.raw_hours_to_first_test = 0
                then 'Immediate'
                when r.raw_hours_to_first_test <= 1
                then 'Within 1 Hour'
                when r.raw_hours_to_first_test <= 6
                then 'Within 6 Hours'
                when r.raw_hours_to_first_test <= 24
                then 'Within 24 Hours'
                else 'After 24 Hours'
            end as test_latency_bucket,

            -- boolean helpers (Tableau-friendly)
            r.tests_taken_count > 0 as has_test,
            r.tests_completed_count > 0 as has_completed_test

        from visitors v
        left join visitor_test_rollup r on v.visitor_key = r.visitor_key
    )

select *
from final
