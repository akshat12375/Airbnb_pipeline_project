{% test null_rate_below(model, column_name, max_null_fraction) %}
with stats as (
  select
    count(*) as total_rows,
    sum(case when {{ column_name }} is null then 1 else 0 end) as null_rows
  from {{ model }}
)
select 'NULL_RATE_EXCEEDED' as error_code, null_rows, total_rows
from stats
where (null_rows::float / nullif(total_rows,0)) > {{ max_null_fraction }}
{% endtest %}


--- checks that the fraction of null values in the specified column is below the max_null_fraction threshold. Fails if the null rate exceeds the threshold. This test is useful for ensuring data quality by limiting the amount of missing data in a critical column.