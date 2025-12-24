with
    visitors as (select visitor_key, gclid_flag from {{ ref("dim_visitors") }}),

    tests as (

        select visitor_key, count(*) as test_count
        from {{ ref("fact_tests") }}
        group by visitor_key

    ),

    final as (

        select
            v.visitor_key,

            v.gclid_flag,
            coalesce(t.test_count, 0) > 0 as has_test,

            case
                when gclid_flag is null
                then 'unknown'

                when gclid_flag = false and coalesce(t.test_count, 0) = 0
                then 'type_1'

                else 'type_2'
            end as traffic_type,

            case
                when gclid_flag is null
                then 'Unknown Attribution'

                when gclid_flag = false and coalesce(t.test_count, 0) = 0
                then 'Organic / Direct (No Test)'

                else 'Paid or Organic (Test Taken)'
            end as traffic_type_label

        from visitors v
        left join tests t on v.visitor_key = t.visitor_key
    )

select *
from final
