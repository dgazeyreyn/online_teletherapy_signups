with
    source as (select * from {{ source("md", "log_tests") }}),

    tests as (

        select
            id,
            test_taken,
            duration,
            completed,
            result,
            ip_address,
            user_agent,
            channel,
            geo,
            created_at,
            updated_at,
            uniq_id,
            city,
            region,
            region_code,
            country,
            country_name,
            continent_code,
            postal,
            latitude,
            longitude,
            timezone,
            utc_offset,
            country_calling_code,
            currency,
            languages,
            asn,
            org,
            test_taken_id,
            site_id

        from source

    )

select *
from tests