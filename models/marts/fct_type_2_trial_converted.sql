with
    visitors as (select * from {{ ref("stg_mind_diagnostics__visitors") }}),

    tests as (select * from {{ ref("stg_mind_diagnostics__tests") }}),

    goals as (select * from {{ ref("stg_better_help__goals") }}),

    one_2_one as (

        select visitors_ip, count(distinct visitors_mduid) as mduid_count
        from visitors
        group by visitors_ip
        having count(distinct visitors_mduid) = 1

    ),

    distinct_test_ips as (select distinct tests_ip as tests_ip from tests),

    deduped_trial_converted as (

        select distinct goals_mduid, goal_name
        from goals
        where goal_name = 'Trial Converted'

    ),

    visitors_bot_handling as (

        select

            visitors.visitors_id,
            visitors.visitors_ip,
            visitors.visitors_os_name,
            visitors.visitors_region,
            visitors.visitors_country_name,
            visitors.visitors_mduid,
            visitors.visitors_browser,
            visitors.visitors_gclid_flag

        from visitors

        join one_2_one on visitors.visitors_ip = one_2_one.visitors_ip
    ),

    visitors_tests as (

        select
            visitors_bot_handling.*,
            case
                when distinct_test_ips.tests_ip is null then false else true
            end as test_taken

        from visitors_bot_handling

        left join
            distinct_test_ips
            on visitors_bot_handling.visitors_ip = distinct_test_ips.tests_ip
    ),

    visitors_tests_type_2 as (

        select *

        from visitors_tests

        where
            visitors_tests.visitors_gclid_flag is true
            or (
                visitors_tests.visitors_gclid_flag is false
                and visitors_tests.test_taken is true
            )
    ),

    trial_converted as (

        select visitors_tests_type_2.*, deduped_trial_converted.goal_name

        from visitors_tests_type_2

        left join
            deduped_trial_converted
            on deduped_trial_converted.goals_mduid = visitors_tests_type_2.visitors_mduid
    ),

    us as (

        select

            visitors_mduid,
            goal_name,
            visitors_region,
            visitors_browser,
            visitors_os_name

        from trial_converted

        where visitors_country_name = 'United States'
    )
select *
from us