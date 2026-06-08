{% snapshot employee_snapshot %}

{{
    config(
            target_schema = 'snapshots',
            unique_key = 'employee_id',
            strategy = 'timestamp',
            updated_at = 'updated_at'
    )
}}
SELECT *
FROM {{ref('int_employee')}}

{% endsnapshot %}