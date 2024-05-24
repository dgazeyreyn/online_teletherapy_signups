with
    source as (select * from {{ source("md", "log_visitor") }}),

    visitors as (

        select

            id as visitors_id,
            ip as visitors_ip,
            os_name as visitors_os_name,
            split(replace(split(substr(geo, (strpos(geo, 'region'))), ',')[offset (0)],'"',''),'=>'
            )[safe_offset(1)] as visitors_region,
            split(replace(split(substr(geo, (strpos(geo, 'country_name'))), ',')[offset (0)],'"',''),'=>'
            )[safe_offset(1)] as visitors_country_name,
            mduid as visitors_mduid,
            split(replace(split(substr(inbound_params, (strpos(inbound_params, 'browser'))), ',')[offset (0)],'"',''),'=>'
            )[safe_offset(1)] as visitors_browser,
            contains_substr(inbound_params, 'gclid') as visitors_gclid_flag,
            *

        from source

    )

select *
from visitors
