{% macro audit_reports() %}

{% set models = [] %}

{% for node in graph.nodes.values() %}
    {% if node.resource_type == 'model'
       and node.name.startswith('rpt_') %}
        {% do models.append(node.name) %}
    {% endif %}
{% endfor %}

{% for model in models %}
select
    '{{ model }}' as model_name,
    count(*) as record_count
from {{ ref(model) }}

{% if not loop.last %}
union all
{% endif %}

{% endfor %}

{% endmacro %}