# SQL-Data-Job-Market-Insights
A SQL queries designed to analyze the most in-demand and highest-paying data engineer skills.

# SQL techniques used in this project:
- Multiple standalone CTEs
- Window functions
- GROUP BY, JOINs, and CASE expressions

For a quick overview, review these:
- [Final Query](optimal_skills.sql)
- [Top Demanded Skills Query](top_demanded_skills.sql)
- [Highest Salary Query](skills_with_highest_sallary.sql)

✅ My aim was to create two small queries which select the highest-paying jobs and the most popular ones according to the job postings. 
Then, they were combined into a single query using multiple standalone CTEs to calculate the score for the most optimal skills.

This project is based on a data warehouse created by Luke Barousse. The schema of the data warehouse is shown below.

<img width="1586" height="1254" alt="1_2_Data_Warehouse" src="https://github.com/user-attachments/assets/52f161a1-a742-4703-bb04-a125cbe11215" />

where:
job_postings_fact - Central table containing job posting details (job titles, locations, salaries, dates, etc.)
company_dim - Company information linked to job postings
skills_dim - Skills catalog with skill names and types
