WITH gl AS(
    SELECT * 
    FROM {{source('raw','sage_gl_postings')}}
)
SELECT * 
FROM gl