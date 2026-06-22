-- Fails if PRICE_PER_NIGHT is zero or negative
select *
from {{ ref('bronze_listings') }}
where price_per_night <= 0 or price_per_night is null
