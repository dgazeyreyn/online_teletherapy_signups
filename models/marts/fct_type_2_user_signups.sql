
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

    deduped_signups as (

        select distinct goals_mduid, goal_name
        from goals
        where goal_name = 'User Signup'

    ),

    visitors_bot_handling as (

        select

            visitors.visitors_id,
            visitors.visitors_ip,
            visitors.visitors_os_name,
            visitors.visitors_geo,
            visitors.visitors_mduid,
            visitors.visitors_inbound_params,
            visitors.visitors_gclid_flag

        from visitors

        join one_2_one on visitors.visitors_ip = one_2_one.visitors_ip
    ),

    visitors_tests as (

        select
            visitors_bot_handling.*,
            case
                when distinct_test_ips.tests_ip is null
                then false
                else true
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

    signups as (

        select visitors_tests_type_2.*, deduped_signups.goal_name

        from visitors_tests_type_2

        left join
            deduped_signups
            on deduped_signups.goals_mduid = visitors_tests_type_2.visitors_mduid
    ),

    strip_left as (

        select

            signups.*,
            -- capturing the positions (via strpos function) of the substrings in geo corresponding to 'region', 'country_name'
            -- stripping everything to the left to get something that looks like this for 'region' (region"=>"california", )
            substr(visitors_geo, (strpos(visitors_geo, 'region'))) as region_strip_left,
            substr(
                visitors_geo, (strpos(visitors_geo, 'country_name'))
            ) as country_strip_left,
            -- doing the exact same thing for the inbound_params field in order to 'strip' out 'browser'
            substr(
                visitors_inbound_params, (strpos(visitors_inbound_params, 'browser'))
            ) as browser_strip_left

        from signups
    ),

    right_strip as (

        select

            strip_left.*,
            -- further splitting on ',' and specifying an offset of 0 in order to remove everything to the right of 'region'
            -- here is an example of what that looks like for 'region' (region=>california)
            -- doing same for both 'country_name' and 'browser' fields
            replace(
                split(region_strip_left, ',')[offset (0)], '"', ''
            ) as region_strip_right,
            replace(
                split(country_strip_left, ',')[offset (0)], '"', ''
            ) as country_strip_right,
            replace(
                split(browser_strip_left, ',')[offset (0)], '"', ''
            ) as browser_strip_right

        from strip_left
    ),

    final_strip as (

        select

            right_strip.*,
            split(right_strip.region_strip_right, '=>')[
                safe_offset(1)
            ] as visitors_region,
            split(right_strip.country_strip_right, '=>')[
                safe_offset(1)
            ] as visitors_country_name,
            split(right_strip.browser_strip_right, '=>')[
                safe_offset(1)
            ] as visitors_browser

        from right_strip
    ),

    us as (

        select

            visitors_mduid,
            goal_name,
            visitors_region,
            visitors_browser,
            visitors_os_name

        from final_strip

        where visitors_country_name = 'United States'
    )
select *
from us
