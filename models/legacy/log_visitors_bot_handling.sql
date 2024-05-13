with
    visitors as (
        select
            log_visitor.id as visitors_id,
            log_visitor.ip as visitors_ip,
            log_visitor.ua.os.name as visitors_os_name,
            log_visitor.geo as visitors_geo,
            log_visitor.mduid as visitors_mduid,
            log_visitor.inbound_params as visitors_inbound_params,
            contains_substr(log_visitor.inbound_params, 'gclid') as visitors_gclid_flag

        from {{ source('mind_diagnostics', 'log_visitor') }}
        join
            (
                select ip, count(distinct mduid) as mduid_count
                from {{ source('mind_diagnostics', 'log_visitor') }}
                group by ip
                having count(distinct mduid) = 1
            ) single_mduid_ips
            on log_visitor.ip = single_mduid_ips.ip
    )

select
    visitors.visitors_id,
    visitors.visitors_ip,
    visitors.visitors_os_name,
    visitors.visitors_geo,
    visitors.visitors_mduid,
    visitors.visitors_inbound_params,
    visitors.visitors_gclid_flag
from visitors
