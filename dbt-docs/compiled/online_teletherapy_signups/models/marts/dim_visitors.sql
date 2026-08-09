with
    visitors as (select * from `mind-diagnostics-414622`.`dbt_dreynolds`.`int_visitors_resolved`),

    final as (

        select
            to_hex(md5(cast(coalesce(cast(mduid as string), '_dbt_utils_surrogate_key_null_') as string))) as visitor_key,

            -- natural key
            mduid,

            -- descriptive attributes
            ip_address,
            browser,
            os_name,
            country_name,
            region,
            gclid_flag,

            -- lifecycle timestamps
            min(created_at) as first_seen_at_utc,
            max(created_at) as last_seen_at_utc

        from visitors
        group by mduid, ip_address, browser, os_name, country_name, region, gclid_flag
    )

select *
from final