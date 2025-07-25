/*
    QUESTION ONE: what are the top 10 paying data analyst role
    Identify the top 10 highest-paying data analyst roles that are available remotely
    focuses on job postings with specified salaries (remove nulls)
    why? highlight the top-paying opportunities for data analyst, offering insights into employment opportunities
*/


SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM   
    job_postings_fact
-- left joined the company_dim table to get the company names for my result--
LEFT JOIN company_dim
    ON company_dim.company_id = job_postings_fact.company_id
WHERE   
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL 
ORDER BY
    salary_year_avg DESC
LIMIT 10;