with
    visitors_raw as (select * from {{ ref("stg_md__visitors") }}),

    -- Identify IPs with exactly one mduid
    one_2_one_ips as (
        select ip_address
        from visitors_raw
        group by ip_address
        having count(distinct mduid) = 1
    ),

    deduped as (

        select v.*
        from visitors_raw v
        join one_2_one_ips o on v.ip_address = o.ip_address
    )

select *
from deduped
