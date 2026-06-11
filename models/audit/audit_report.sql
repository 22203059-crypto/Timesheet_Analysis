{% set query %}

select
    table_name,
    table_schema
from information_schema.tables
where table_name ilike 'RPT_%'

{% endset %}

{% set results = run_query(query) %}

{% for row in results.rows %}

select
    '{{ row[0] }}' as table_name,
    source_system,
    max(updated_at) as updated_at
from TIMESHEET.{{ row[1] }}.{{ row[0] }}
group by source_system

{% if not loop.last %}
union all
{% endif %}

{% endfor %}