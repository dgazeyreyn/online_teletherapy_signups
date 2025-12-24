with
    visitors as (

        select visitor_key, browser, os_name, region, country_name
        from {{ ref("dim_visitors") }}

    ),

    traffic as (

        select visitor_key, traffic_type from {{ ref("mart_visitor_traffic_type") }}

    ),

    conversion_flags as (

        select
            visitor_key,

            max(case when goal_name = 'User Signup' then 1 else 0 end) as has_signup,
            max(
                case when goal_name = 'Trial Converted' then 1 else 0 end
            ) as has_trial_conversion

        from {{ ref("fact_conversions") }}
        group by visitor_key

    ),

    final as (

        select
            v.visitor_key,
            v.browser,
            v.os_name,
            v.region,

            coalesce(c.has_signup, 0) as has_signup,
            coalesce(c.has_trial_conversion, 0) as has_trial_conversion

        from visitors v
        join traffic t on v.visitor_key = t.visitor_key
        left join conversion_flags c on v.visitor_key = c.visitor_key

        where t.traffic_type = 'type_2' and v.country_name = 'United States'
    )

select *
from final
