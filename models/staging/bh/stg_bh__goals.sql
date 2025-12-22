with
    source as (select * from {{ source("bh", "goals") }}),

    goals as (

        select

            {{
                dbt_utils.generate_surrogate_key(
                    [
                        "stat_datetime",
                        "goal_name",
                        "stat_ad_id",
                        "stat_affiliate_info5",
                    ]
                )
            }} as goal_id,
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
