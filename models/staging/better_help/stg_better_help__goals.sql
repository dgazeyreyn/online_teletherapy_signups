with
    source as (select * from {{ source("better_help", "better_help_full") }}),

    goals as (select stat_affiliate_info5 as goals_mduid, goal_name from source)

select *
from goals
