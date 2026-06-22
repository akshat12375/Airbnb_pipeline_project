{% test non_negative(model, column_names) %}
select *
from {{ model }}
where (
{% for col in column_names %}
  {{ col }} < 0{% if not loop.last %} OR{% endif %}
{% endfor %}
)
{% endtest %}
