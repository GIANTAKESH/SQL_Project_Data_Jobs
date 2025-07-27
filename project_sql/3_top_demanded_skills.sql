/*
   QUESTION 3: what are the most in-demand skills for data analyst?
   - join job postings to inner join table similar to query 2
   -identify the top 5 in-demand skills for data analyst
   -focus on all job postings
   -why? retrieves the top 5 skills with the highest demand in the job market'
      providing insights into the most valuable skills fir job seekers.
*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
--inner joined the skills_job_dim table and skills_dim table to get the skills name
INNER JOIN skills_job_dim
    ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND 
    job_work_from_home = TRUE  --filtering for remote work--
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;