with
    tests as (select * from {{ ref("stg_md__tests") }}),

    visitors_resolved as (

        select mduid, ip_address from {{ ref("int_visitors_resolved") }}

    ),

    visitors_dim as (select visitor_key, mduid from {{ ref("dim_visitors") }}),

    tests_with_mduid as (

        select
            t.id,
            vr.mduid,

            -- test attributes
            t.test_taken,
            t.duration,
            t.completed,
            t.result,

            -- timestamps
            t.created_at as test_taken_at_utc

        from tests t
        join visitors_resolved vr on t.ip_address = vr.ip_address
    ),

    final as (

        select
            twm.id,
            vd.visitor_key,
            twm.test_taken,
            twm.duration,
            twm.completed,
            twm.result,
            twm.test_taken_at_utc
        from tests_with_mduid twm
        join visitors_dim vd on twm.mduid = vd.mduid
    )

select *
from final
