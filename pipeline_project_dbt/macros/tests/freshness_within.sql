{% test freshness_within(model, timestamp_column, max_age_hours) %}
with latest as (
  select max({{ timestamp_column }}) as latest_ts
  from {{ model }}
)
select 'STALE_DATA' as error_code, datediff('hour', latest_ts, current_timestamp()) as age_hours
from latest
where latest_ts is null or datediff('hour', latest_ts, current_timestamp()) > {{ max_age_hours }}
{% endtest %}



--- Checks that the latest timestamp in the specified column is within the max_age_hours threshold. Fails if the latest timestamp is null or if the age in hours exceeds the threshold. This test is useful for ensuring data freshness in a table, especially for time-sensitive data.