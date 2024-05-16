with source as (select * from {{ source("better_help", "better_help_full") }})

select *
from source
