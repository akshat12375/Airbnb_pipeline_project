{{
  config(
    materialized = 'ephemeral',
    )
}}

WITH bookings AS 
(
    SELECT 
        BOOKING_ID,
        BOOKING_DATE,
        BOOKING_STATUS,
        CREATED_AT
    FROM 
        {{ ref('one_big_table') }}
)
SELECT * FROM bookings