-- Fails if TOTAL_AMOUNT does not equal NIGHTS_BOOKED * BOOKING_AMOUNT
select *
from {{ ref('silver_bookings') }}
where coalesce(total_amount, 0) != coalesce(nights_booked * booking_amount, 0)
