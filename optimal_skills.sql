--- optimal skills
WITH demanded_skill AS (
    SELECT DISTINCT 
        s.skills, 
        COUNT(s.skills) OVER(PARTITION BY s.skills) AS popularity  
    FROM 
        job_postings_fact AS j 
        INNER JOIN skills_job_dim AS sjd ON j.job_id=sjd.job_id 
        INNER JOIN skills_dim AS s ON sjd.skill_id=s.skill_id
),
salary_hour AS (
    SELECT 
        job_id,
        job_title,
        CASE 
            WHEN salary_rate = 'year' THEN round(salary_year_avg / 2080)
            WHEN salary_rate = 'hour' THEN round(salary_hour_avg)
            ELSE NULL
        END AS median_hourly_wage
    FROM 
        job_postings_fact 
    WHERE 
        ((salary_rate = 'year' AND salary_year_avg IS NOT NULL)
        OR 
        (salary_rate = 'hour' AND salary_hour_avg IS NOT NULL)) 
),
high_salary AS (
    SELECT 
        s.skills,  
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY j.median_hourly_wage) AS median_hourly_wage
    FROM salary_hour AS j 
        INNER JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id 
        INNER JOIN skills_dim AS s ON sjd.skill_id = s.skill_id
    GROUP BY (s.skills)
)
    SELECT 
        RANK() OVER(ORDER BY hs.median_hourly_wage * ds.popularity DESC) AS rank_value,
        hs.skills,  
        ROUND(LN(hs.median_hourly_wage * ds.popularity),2) AS score,
        hs.median_hourly_wage,
        ds.popularity
    FROM demanded_skill AS ds 
        INNER JOIN high_salary AS hs ON ds.skills=hs.skills

/*
This query merges the previous two steps to identify the most optimal 
 data skills and rank them. The score is determined 
 by multiplying the median hourly wage by the skills popularity.

The data shows that Python and SQL outbound every other skill, 
leading in job posting popularity by a margin of over 500,000. 
However, this massive volume slightly overshadows the wage impact, 
which peaked among Linux distributions like Fedora and Ubuntu.

Output:
┌────────────┬─────────────────┬────────┬────────────────────┬────────────┐
│ rank_value │     skills      │ score  │ median_hourly_wage │ popularity │
│   int64    │     varchar     │ double │       double       │   int64    │
├────────────┼─────────────────┼────────┼────────────────────┼────────────┤
│          1 │ python          │   17.6 │               58.0 │     759081 │
│          2 │ sql             │  17.55 │               55.0 │     758824 │
│          3 │ aws             │  16.75 │               62.0 │     302245 │
│          4 │ azure           │  16.64 │               60.0 │     280137 │
│          5 │ spark           │  16.47 │               64.0 │     222464 │
│          6 │ r               │  16.39 │               55.0 │     237602 │
│          7 │ tableau         │  16.33 │               51.0 │     241876 │
│          8 │ excel           │  16.13 │               41.0 │     245645 │
│          9 │ java            │  16.11 │               60.0 │     164723 │
│         10 │ power bi        │  16.11 │               48.0 │     205785 │
│         11 │ snowflake       │  15.84 │               62.0 │     122174 │
│         12 │ databricks      │  15.84 │               62.0 │     121834 │
│         13 │ hadoop          │  15.81 │               62.0 │     118739 │
│         14 │ scala           │  15.78 │               65.0 │     109664 │
│         15 │ sas             │  15.77 │               48.0 │     146388 │
│         16 │ gcp             │  15.71 │               61.0 │     108917 │
│         17 │ airflow         │  15.66 │               67.0 │      94671 │
│         18 │ kafka           │  15.66 │               65.0 │      96902 │
│         19 │ git             │  15.55 │               59.0 │      95940 │
│         20 │ nosql           │  15.45 │               60.0 │      85863 │
│          · │  ·              │     ·  │                 ·  │         ·  │
│          · │  ·              │     ·  │                 ·  │         ·  │
│          · │  ·              │     ·  │                 ·  │         ·  │
│        214 │ mlr             │   8.97 │               40.0 │        196 │
│        215 │ lisp            │   8.82 │               48.0 │        141 │
│        216 │ workfront       │   8.76 │               46.0 │        138 │
│        217 │ play framework  │   8.75 │               48.0 │        131 │
│        218 │ xamarin         │    8.7 │               58.0 │        103 │
│        219 │ dlib            │   8.49 │               64.0 │         76 │
│        220 │ wrike           │   8.42 │               36.0 │        126 │
│        221 │ pascal          │   8.42 │               44.0 │        103 │
│        222 │ tidyr           │    8.4 │               42.0 │        106 │
│        223 │ ocaml           │   8.36 │               65.0 │         66 │
│        224 │ gatsby          │   8.19 │               71.0 │         51 │
│        225 │ nuix            │   8.08 │               30.5 │        106 │
│        226 │ fastify         │   7.82 │               64.0 │         39 │
│        227 │ mattermost      │   7.72 │               58.0 │         39 │
│        228 │ kali            │   7.45 │               43.0 │         40 │
│        229 │ homebrew        │   7.12 │               47.5 │         26 │
│        230 │ chainer         │   7.01 │               50.5 │         22 │
│        231 │ shogun          │   6.52 │               40.0 │         17 │
│        232 │ nuxt.js         │    6.1 │               16.0 │         28 │
│        233 │ microsoft lists │   5.78 │               25.0 │         13 │
└────────────┴─────────────────┴────────┴────────────────────┴────────────┘
  233 rows (40 shown)      use .last to show entire result      5 columns

*/