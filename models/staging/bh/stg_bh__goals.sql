with
    source as (select * from {{ source("bh", "goals") }}),

    goals as (

        select

            stat_affiliate_info5 as goals_mduid,
            *

        from source

    )

select *
from goals
