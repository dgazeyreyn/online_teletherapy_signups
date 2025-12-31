with
    goals as (

        select
            mduid,
            goal_name,
            conversion_at_utc,
            stat_ad_id,
            stat_affiliate_info1,
            stat_affiliate_info2,
            stat_affiliate_info3,
            stat_affiliate_info4,
            country_name
        from {{ ref("stg_bh__goals") }}

    ),

    visitors as (select visitor_key, mduid from {{ ref("dim_visitors") }}),

    final as (

        select
            {{
                dbt_utils.generate_surrogate_key(
                    [
                        "goals.mduid",
                        "goals.goal_name",
                        "goals.conversion_at_utc",
                        "goals.stat_ad_id",
                    ]
                )
            }} as conversion_key,

            visitors.visitor_key,
            goals.mduid,

            goals.goal_name,
            goals.conversion_at_utc,

            goals.stat_affiliate_info1,
            goals.stat_affiliate_info2,
            goals.stat_affiliate_info3,
            goals.stat_affiliate_info4,
            goals.stat_affiliate_info4 is not null as results_screen,

            goals.country_name

        from goals
        left join visitors on goals.mduid = visitors.mduid
    )

select *
from final
