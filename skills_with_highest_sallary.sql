--- hightest salary
WITH salary_hour AS (
    SELECT 
        job_id,
        job_title,
        CASE 
            WHEN salary_rate = 'year' THEN round(salary_year_avg / 2080)
            WHEN salary_rate = 'hour' THEN round(salary_hour_avg)
            ELSE NULL
        END AS salary
    FROM 
        job_postings_fact 
    WHERE 
        ((salary_rate = 'year' AND salary_year_avg IS NOT NULL)
        OR (salary_rate = 'hour' AND salary_hour_avg IS NOT NULL))
)
    SELECT 
        s.skills,  
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY j.salary) AS median_hourly_wage
    FROM 
        salary_hour AS j 
        INNER JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id 
        INNER JOIN skills_dim AS s ON sjd.skill_id = s.skill_id
    GROUP BY 
        (s.skills) 
    ORDER BY 
        median_hourly_wage DESC

/* 
    The aim of this query was to select the highest-paying data 
    skills on the market, along with their hourly wages

Output:
┌─────────────────┬────────────────────┐
│     skills      │ median_hourly_wage │
│     varchar     │       double       │
├─────────────────┼────────────────────┤
│ fedora          │               88.0 │
│ debian          │               83.0 │
│ puppet          │               76.0 │
│ rust            │               75.0 │
│ golang          │               72.0 │
│ lua             │               72.0 │
│ ruby on rails   │               72.0 │
│ svelte          │               72.0 │
│ gatsby          │               71.0 │
│ redhat          │               71.0 │
│ dplyr           │               70.0 │
│ node            │               70.0 │
│ watson          │               70.0 │
│ next.js         │               70.0 │
│ codecommit      │               70.0 │
│ wsl             │               70.0 │
│ mongo           │               70.0 │
│ redis           │               69.5 │
│ hugging face    │               69.0 │
│ ansible         │               68.0 │
│   ·             │                 ·  │
│   ·             │                 ·  │
│   ·             │                 ·  │
│ tidyr           │               42.0 │
│ excel           │               41.0 │
│ wire            │               41.0 │
│ sheets          │               41.0 │
│ word            │               41.0 │
│ spss            │               41.0 │
│ ringcentral     │               40.0 │
│ shogun          │               40.0 │
│ mlr             │               40.0 │
│ ms access       │               40.0 │
│ laravel         │               39.0 │
│ powerbi         │               38.0 │
│ wrike           │               36.0 │
│ colocation      │               35.0 │
│ spreadsheet     │               33.0 │
│ outlook         │               32.0 │
│ nuix            │               30.5 │
│ symfony         │               29.5 │
│ microsoft lists │               25.0 │
│ nuxt.js         │               16.0 │
└─────────────────┴────────────────────┘
  233 rows (40 shown)        2 columns
    
*/