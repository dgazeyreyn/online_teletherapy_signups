with
    source as (select * from {{ source("mind_diagnostics", "log_visitor") }}),

    visitors as (

        select

            id as visitors_id,
            ip as visitors_ip,
            ua.os.name as visitors_os_name,
            geo as visitors_geo,
            mduid as visitors_mduid,
            inbound_params as visitors_inbound_params,
            contains_substr(inbound_params, 'gclid') as visitors_gclid_flag

        from source

    )

select *
from visitors
