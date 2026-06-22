-- Fails if booking_id is null in one_big_table
select *
from {{ ref('one_big_table') }}
where booking_id is null
