with
    visitors as (select * from {{ ref("mart_visitor_type2_us_outcomes") }}),

    tests as (

        select visitor_key, test_taken, completed, duration, test_taken_at_utc
        from {{ ref("fact_tests") }}

    ),

    visitor_tests as (

        select
            v.visitor_key,

            -- volume metrics
            count(t.test_taken_at_utc) as tests_started,
            countif(t.completed) as tests_completed,

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

            -- timing
            min(t.test_taken_at_utc) as first_test_at,
            max(t.test_taken_at_utc) as last_test_at,

            min(
                timestamp_diff(t.test_taken_at_utc, v.first_seen_at_utc, hour)
            ) as raw_hours_to_first_test

        from visitors v
        left join tests t on v.visitor_key = t.visitor_key

        group by v.visitor_key
    ),

    final as (

        select
            vt.visitor_key,

            -- test counts
            vt.tests_started,
            vt.tests_completed,

            safe_divide(vt.tests_completed, vt.tests_started) as test_completion_rate,

            -- test descriptors
            vt.first_test_taken,
            vt.last_test_taken,
            vt.first_completed_test_taken,
            vt.last_completed_test_taken,

            -- timestamps
            vt.first_test_at,
            vt.last_test_at,

            -- cleaned latency
            case
                when vt.raw_hours_to_first_test < 0
                then null
                else vt.raw_hours_to_first_test
            end as hours_to_first_test,

            -- latency buckets
            case
                when vt.raw_hours_to_first_test is null
                then 'No Test'
                when vt.raw_hours_to_first_test < 0
                then 'Test Before First Seen'
                when vt.raw_hours_to_first_test = 0
                then 'Immediate'
                when vt.raw_hours_to_first_test <= 1
                then 'Within 1 Hour'
                when vt.raw_hours_to_first_test <= 6
                then 'Within 6 Hours'
                when vt.raw_hours_to_first_test <= 24
                then 'Within 24 Hours'
                else 'After 24 Hours'
            end as test_latency_bucket,

            -- boolean helpers (Tableau / modeling friendly)
            vt.tests_started > 0 as has_test,
            vt.tests_completed > 0 as has_completed_test

        from visitor_tests vt
    )

select *
from final
