with
    signups as (
        select visitors_tests_type_2.*, deduped_signups.goal_name
        from mind-diagnostics-414622.dbt_dreynolds.visitors_tests_type_2
        left join
            (
                select distinct stat_affiliate_info5, goal_name
                from mind-diagnostics-414622.md.better_help_full
                where goal_name = 'User Signup'
            ) as deduped_signups
            on deduped_signups.stat_affiliate_info5 = visitors_tests_type_2.visitors_mduid
    ),
    strip_left as (
        select
            signups.*,
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
        from signups
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
        select distinct
            visitors_mduid,
            goal_name,
            visitors_region,
            visitors_browser,
            visitors_os_name
        from final_strip
        where visitors_country_name = 'United States'
    )
    select * from us
