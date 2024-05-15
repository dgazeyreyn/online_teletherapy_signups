with
    visitors_bot_handling as (
        select
            log_visitor.id as visitors_id,
            log_visitor.ip as visitors_ip,
            log_visitor.ua.os.name as visitors_os_name,
            log_visitor.geo as visitors_geo,
            log_visitor.mduid as visitors_mduid,
            log_visitor.inbound_params as visitors_inbound_params,
            contains_substr(log_visitor.inbound_params, 'gclid') as visitors_gclid_flag
        from {{ source("mind_diagnostics", "log_visitor") }}
        join
            (
                select ip, count(distinct mduid) as mduid_count
                from {{ source("mind_diagnostics", "log_visitor") }}
                group by ip
                having count(distinct mduid) = 1
            ) one_to_one_mduid_ip
            on log_visitor.ip = one_to_one_mduid_ip.ip
    ),
    visitors_tests as (
        select
            visitors_bot_handling.*,
            case
                when distinct_ip_addresses.ip_address is null then false else true
            end as test_taken
        from visitors_bot_handling
        left join
            (
                select distinct ip_address as ip_address
                from {{ source("mind_diagnostics", "log_tests") }}
            ) distinct_ip_addresses
            on visitors_bot_handling.visitors_ip = distinct_ip_addresses.ip_address
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
            (
                select distinct stat_affiliate_info5, goal_name
                from {{ source("better_help", "better_help_full") }}
                where goal_name = 'Trial Converted'
            ) as deduped_trial_converted
            on deduped_trial_converted.stat_affiliate_info5
            = visitors_tests_type_2.visitors_mduid
    ),
    strip_left as (
        select
            trial_converted.*,
            -- Capturing the positions (via strpos function) of the substrings in geo
            -- corresponding to 'region', 'country_name'
            -- Stripping everything to the left to get something that looks like this
            -- for 'region' (region"=>"California", )
            substr(visitors_geo, (strpos(visitors_geo, 'region'))) as region_strip_left,
            substr(
                visitors_geo, (strpos(visitors_geo, 'country_name'))
            ) as country_strip_left,
            -- Doing the exact same thing for the inbound_params field in order to
            -- 'strip' out 'browser'
            substr(
                visitors_inbound_params, (strpos(visitors_inbound_params, 'browser'))
            ) as browser_strip_left
        from trial_converted
    ),
    right_strip as (
        select
            strip_left.*,
            -- Further splitting on ',' and specifying an offset of 0 in order to
            -- remove everything to the right of 'region'
            -- Here is an example of what that looks like for 'region'
            -- (region=>California)
            -- Doing same for both 'country_name' and 'browser' fields
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
            ] as visitors_browser,
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
