-- top demanded skills
    SELECT DISTINCT 
        s.type, 
        s.skills, 
        COUNT(s.skills) OVER(PARTITION BY s.skills) AS popularity  
    FROM 
        job_postings_fact AS j 
        INNER JOIN skills_job_dim AS sjd ON j.job_id=sjd.job_id 
        INNER JOIN skills_dim AS s ON sjd.skill_id=s.skill_id
    ORDER BY 
      CASE s.type
        WHEN 'programming' THEN 1
        WHEN 'cloud'       THEN 2
        WHEN 'database'    THEN 3
        ELSE 4
    END ASC,
    popularity DESC;

/* The aim of the query was to select the most common data skills 
    on the market, alongside their categories.
Output:
┌───────────────┬─────────────────┬────────────┐
│     type      │     skills      │ popularity │
│    varchar    │     varchar     │   int64    │
├───────────────┼─────────────────┼────────────┤
│ programming   │ python          │     759081 │
│ programming   │ sql             │     758824 │
│ programming   │ r               │     237602 │
│ programming   │ java            │     164723 │
│ programming   │ sas             │     146388 │
│ programming   │ scala           │     109664 │
│ programming   │ nosql           │      85863 │
│ programming   │ go              │      70815 │
│ programming   │ mongodb         │      68980 │
│ programming   │ javascript      │      48292 │
│ programming   │ c++             │      39793 │
│ programming   │ shell           │      34889 │
│ programming   │ c#              │      31759 │
│ programming   │ c               │      27474 │
│ programming   │ vba             │      22525 │
│ programming   │ matlab          │      21295 │
│ programming   │ bash            │      18700 │
│ programming   │ t-sql           │      16676 │
│ programming   │ ruby            │      15674 │
│ programming   │ html            │      14693 │
│      ·        │  ·              │          · │
│      ·        │  ·              │          · │
│      ·        │  ·              │          · │
│ webframeworks │ nuxt.js         │         28 │
│ libraries     │ mlpack          │         28 │
│ webframeworks │ ember.js        │         27 │
│ other         │ homebrew        │         26 │
│ libraries     │ chainer         │         22 │
│ libraries     │ shogun          │         17 │
│ async         │ microsoft lists │         13 │
│ async         │ dingtalk        │          8 │
│ libraries     │ huggingface     │          6 │
│ webframeworks │ deno            │          5 │
│ analyst_tools │ esquisse        │          4 │
│ libraries     │ gtx             │          4 │
│ webframeworks │ asp.netcore     │          3 │
│ async         │ workzone        │          2 │
│ sync          │ rocketchat      │          2 │
│ async         │ wimi            │          1 │
│ webframeworks │ rubyon rails    │          1 │
│ async         │ swit            │          1 │
│ libraries     │ fann            │          1 │
│ analyst_tools │ msaccess        │          1 │
└───────────────┴─────────────────┴────────────┘
  259 rows (40 shown)                3 columns
    */
