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
        from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_bh__goals`

    ),

    visitors as (select visitor_key, mduid from `mind-diagnostics-414622`.`dbt_dreynolds`.`dim_visitors`),

    final as (

        select
            to_hex(md5(cast(coalesce(cast(goals.mduid as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(goals.goal_name as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(goals.conversion_at_utc as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(goals.stat_ad_id as string), '_dbt_utils_surrogate_key_null_') as string))) as conversion_key,

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