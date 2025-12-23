with visitors as (select * from {{ ref("int_visitors_resolved") }})

select
    {{ dbt_utils.generate_surrogate_key(["mduid"]) }} as visitor_key,

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
