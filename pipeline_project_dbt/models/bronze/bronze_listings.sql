{{ config(materialized='incremental') }}


SELECT * FROM  {{ source('source_stage', 'listings') }}

{% if is_incremental() %}
    WHERE CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{ this }})
    -- I could have used the ref but 'this' is more efficient
    -- using coalesce to handle the case when the table is empty and there is no max created_at
{% endif %}