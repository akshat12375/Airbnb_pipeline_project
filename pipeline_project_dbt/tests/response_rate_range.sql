-- Fails if RESPONSE_RATE is outside 0-100 or null
select *
from {{ ref('bronze_hosts') }}
where response_rate is null or response_rate < 0 or response_rate > 100
