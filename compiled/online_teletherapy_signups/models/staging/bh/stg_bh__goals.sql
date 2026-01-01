with
    source as (select * from `mind-diagnostics-414622`.`md`.`goals`),

    goals as (

        select

            to_hex(md5(cast(coalesce(cast(stat_datetime as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(goal_name as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(stat_ad_id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(stat_affiliate_info5 as string), '_dbt_utils_surrogate_key_null_') as string))) as goal_id,
            stat_datetime as conversion_at_est,
            timestamp(
                datetime(stat_datetime), 'America/New_York'
            ) as conversion_at_utc,
            goal_name,
            country_name,
            stat_ad_id,
            stat_affiliate_info1,
            stat_affiliate_info2,
            stat_affiliate_info3,
            stat_affiliate_info4,
            stat_affiliate_info5 as mduid,
            conversionsmobile_affiliate_click_id

        from source

    )

select *
from goals