{{config(materialized='incremental', unique_key='booking_id')}}

-- We are using the unique key because we want to load the data in the UPSERT manner
-- Only materialized as incremental is used when we need an increental load 
SELECT 
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE,
    {{ multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT',2) }} AS TOTAL_AMOUNT,
    SERVICE_FEE, 
    CLEANING_FEE, 
    BOOKING_STATUS,
    CREATED_AT
FROM 
    {{ ref('bronze_bookings') }}

    