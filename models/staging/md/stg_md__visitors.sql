with
    source as (select * from {{ source("md", "log_visitor") }}),

    visitors as (

        select

            id,
            ip as ip_address,
            user_agent,
            browser_name,
            browser_version,
            browser_major,
            engine_name,
            engine_version,
            os_name,
            os_version,
            device_vendor,
            device_model,
            device_type,
            arch,
            geo,
            regexp_extract(geo, r'"region"=>"([^"]+)"') as region,
            regexp_extract(geo, r'"country_name"=>"([^"]+)"') as country_name,
            -- os_name,
            mduid,
            created_at,
            updated_at,
            inbound_params,
            regexp_extract(inbound_params, r'"browser"=>"([^"]+)"') as browser,
            contains_substr(inbound_params, 'gclid') as gclid_flag

        from source

    )

select *
from visitors
