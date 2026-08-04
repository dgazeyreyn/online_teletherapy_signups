with
    visitors_raw as (select * from `mind-diagnostics-414622`.`dbt_dreynolds`.`stg_md__visitors`),

    -- Identify IPs with exactly one mduid
    one_2_one_ips as (
        select ip_address
        from visitors_raw
        group by ip_address
        having count(distinct mduid) = 1
    ),

    resolved as (

        select
            v.mduid,
            v.ip_address,
            v.browser,
            v.os_name,
            v.country_name,
            v.region,
            v.gclid_flag,
            v.created_at
        from visitors_raw v
        join one_2_one_ips o on v.ip_address = o.ip_address
    )

select *
from resolved