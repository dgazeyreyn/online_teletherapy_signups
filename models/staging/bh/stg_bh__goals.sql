with source as (select * from {{ source("bh", "goals") }})

select goal_name, stat_affiliate_info5 as goals_mduid
from source
