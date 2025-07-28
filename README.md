# INTRODUCTION
This project explores data analyst job postings from 2023 using SQL, with a focus on identifying the most in-demand and highest-paying skills. By analyzing structured job market data, we aim to uncover key trends in technologies, tools, and qualifications that lead to better compensation and remote opportunities.

SQL queries? check them out here : [project_sql](/project_sql/)

# BACKGROUNG
As the data industry grows rapidly, understanding what makes a data analyst role valuable and competitive is more important than ever. This project uses real 2023 job posting data to uncover the salary trends, in-demand skills, and key tools that define the modern data analyst job market.
Through SQL-based analysis, this project aims to answer the following questions:
1. What are the top 10 highest-paying data analyst roles?

2. What skills are required for those top-paying jobs?

3. What are the most in-demand skills for data analysts overall?

4. What are the top skills based on salary alone?

5. What are the most optimal skills to learn — those that are both in demand and high-paying?

By answering these, the project helps job seekers and professionals prioritize learning the tools that offer the best return in today's competitive data landscape.

# TOOLS I USED
This project was built using the following tools, each playing a key role in the workflow from data analysis to collaboration:
- SQL – The backbone of all data exploration and analysis, used to query job posting data and extract insights.

- PostgreSQL – A powerful open-source relational database used to store and manage the job listings and skill data.

- Visual Studio Code – A lightweight and versatile code editor used to write and manage SQL scripts efficiently.

- Git – Version control tool used to track changes and manage project history.

- GitHub – Used for hosting the project repository, collaborating, and sharing findings publicly.

# THE ANALYSIS
Each query in this project was designed to explore a specific aspect of the data analyst job market. Here's a brief overview of how I approached each question:

### 1. TOP PAYING DATA ANALYST JOBS
To identify the highest-paying data analyst roles, I queried job postings where the job title matched Data Analyst, a valid yearly salary was provided, and the role was listed as remote. I then sorted the results by average salary in descending order and limited the output to the top 10.

```sql
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
```
Here is a Breakdown of the Top Remote Data Analyst Jobs in 2023:
 - The highest-paying job is at Mantys, offering $650,000/year.

- Many roles have senior or director-level titles (e.g., at Meta, AT&T, SmartAsset), showing that experience = higher pay.

- All roles are remote, full-time, and offer $184,000+ annually.

- Job postings span the entire year, indicating consistent demand.

![Top Paying Jobs](assets\1_top_paying_jobs.png)

*A Bar Chart Visualization of the Top 10 Highest-Paying Remote Data Analyst Jobs, Showing Each Role's Salary and Hiring Company; ChatGbt generated this chart for my sql query result*


### 2. SKILLS FOR TOP PAYING JOBS
To answer this, I analyzed the skills associated with the highest-paying remote data analyst roles. By joining job postings with skill data, I identified which tools and technologies are most commonly required in top-paying positions. This reveals what technical skills are valued in the highest salary brackets for remote jobs.

```sql
-- created a CTE  
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
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
    LIMIT 10
)
SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
-- inner joined the skills_job_dim table and skills_dim table to get the skills name 
INNER JOIN skills_job_dim
    ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC
```
Here is a Breakdown of the Most In-Demand Skills for the Top 10 Highest-Paying Remote Data Analyst Jobs in 2023:
- Most common skills: SQL, Python, Tableau, and Excel appear in nearly all top-paying roles.

- High-paying tools: Cloud platforms like AWS, Azure, Snowflake, and tools like Databricks, Power BI, and Jupyter are frequently listed.

- Extra edge: Some roles require DevOps or team tools (Jira, Bitbucket, Confluence), showing a blend of analytics and engineering.

![Skills For Top Paying Jobs](assets\2_top_paying_job_skill.png)

*A Bar Chart Visualizing the Top Skills Most Frequently Required in High-Paying Remote Data Analyst Roles; ChatGpt generated this vhart from my SQL query results*

### 3. IN-DEMAND SKILLS FOR DATA ANALYSTS
To find the most in-demand skills, I analyzed how often each skill appears across all remote data analyst job postings. By counting skill frequency, this query highlights the tools and technologies employers request most often for remote roles. I then limited the result to the top 5 most frequently mentioned skills.

```sql
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
```
Here is a Breakdown of the Most In-Demand Skills for Remote Data Analysts in 2023:
- SQL is the clear leader with 7,291 mentions, confirming it's the most essential skill for data analysts.

- Excel and Python follow closely, highlighting their continued importance in both basic and advanced analysis tasks.

- Tableau and Power BI show strong demand for data visualization and BI tools.

| Skill    | Demand Count |
| -------- | ------------ |
| SQL      | 7,291        |
| Excel    | 4,611        |
| Python   | 4,330        |
| Tableau  | 3,745        |
| Power BI | 2,609        |

*Table of the Most In-Demand Skills in Remote Data Analyst Job Postings*

### 4. SKILLS BASED ON SALARY
To answer this, I calculated the average salary for each skill across remote data analyst job postings. I then limited the results to the top 25 skills with the highest average salaries. This highlights which tools and technologies are most valued in high-paying remote roles.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
--inner joined the skills_job_dim table and skills_dim table to get the skills name
INNER JOIN skills_job_dim
    ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE  --filtering for remote work--
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Here ia a breakdown o the most demanded skills for data analysts in 2023:
- Niche tools like svn, solidity, and couchbase top the list, likely tied to specialized roles.

- AI/ML skills such as mxnet, keras, and hugging face are linked to higher salaries.

- DevOps and cloud tools (terraform, gitlab, airflow) show strong earning potential.

- Programming skills like golang and scala also appear in top-paying roles.

| Skill        | Avg Salary (\$) |
| ------------ | --------------- |
| svn          | 400,000         |
| solidity     | 179,000         |
| couchbase    | 160,515         |
| datarobot    | 155,486         |
| golang       | 155,000         |
| mxnet        | 149,000         |
| dplyr        | 147,633         |
| vmware       | 147,500         |
| terraform    | 146,734         |
| twilio       | 138,500         |
| gitlab       | 134,126         |
| kafka        | 129,999         |
| puppet       | 129,820         |
| keras        | 127,013         |
| pytorch      | 125,226         |
| perl         | 124,686         |
| ansible      | 124,370         |
| hugging face | 123,950         |
| tensorflow   | 120,647         |
| cassandra    | 118,407         |
| notion       | 118,092         |

*Table of Top 25 Highest-Paying Skills in Remote Data Analyst Roles*

### 5. MOST OPTIMAL SKILL TO LEARN
To answer this, I combined average salary and demand frequency to identify skills that are both high-paying and highly in demand. These represent the most valuable skills for remote data analysts. I limited the results to the top 25 optimal skills based on this balance.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id,
    skills_dim.skills
HAVING 
    COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
Here is a Breakdown of the Most Optimal Skills for Remote Data Analysts in 2023;
- Core skills like Python, R, and Tableau rank high in both usage and pay, making them essential for analysts.

- Cloud tools such as Snowflake, Azure, AWS, and BigQuery show strong value in roles tied to modern data infrastructure.

- BI platforms like Looker, Qlik, and SSRS are commonly required in high-paying positions.

- Programming and data engineering skills (e.g., Go, Java, Spark, Hadoop) are well-represented, showing the advantage of technical versatility.

| Skill ID | Skill      | Demand Count | Avg Salary (\$) |
| -------- | ---------- | ------------ | --------------- |
| 8        | Go         | 27           | 115,320         |
| 234      | Confluence | 11           | 114,210         |
| 97       | Hadoop     | 22           | 113,193         |
| 80       | Snowflake  | 37           | 112,948         |
| 74       | Azure      | 34           | 111,225         |
| 77       | BigQuery   | 13           | 109,654         |
| 76       | AWS        | 32           | 108,317         |
| 4        | Java       | 17           | 106,906         |
| 194      | SSIS       | 12           | 106,683         |
| 233      | Jira       | 20           | 104,918         |
| 79       | Oracle     | 37           | 104,534         |
| 185      | Looker     | 49           | 103,795         |
| 2        | NoSQL      | 13           | 101,414         |
| 1        | Python     | 236          | 101,397         |
| 5        | R          | 148          | 100,499         |
| 78       | Redshift   | 16           | 99,936          |
| 187      | Qlik       | 13           | 99,631          |
| 182      | Tableau    | 230          | 99,288          |
| 197      | SSRS       | 14           | 99,171          |
| 92       | Spark      | 13           | 99,077          |
| 13       | C++        | 11           | 98,958          |
| 186      | SAS        | 63           | 98,902          |
| 7        | SAS        | 63           | 98,902          |
| 61       | SQL Server | 35           | 97,786          |
| 9        | JavaScript | 20           | 97,587          |

*Table of Top 25 Optimal Skills for Remote Data Analysts*

# WHAT I LEARNED 
This was my first data project, and it was a great opportunity to apply and grow my SQL skills in a real-world context.
Through this project, I learned how to:
- Use CTEs (Common Table Expressions) to structure complex queries more clearly

- Apply data aggregation functions like COUNT(), ROUND(), and AVG() to extract meaningful insights

- Filter and sort large datasets efficiently to answer targeted business questions

- Combine multiple tables using JOINs to connect job, company, and skill data

- Most importantly, I leveled up my problem-solving skills by writing SQL queries to solve practical, real-world questions about the job market

This project gave me a strong foundation in SQL and a better understanding of how to use data to uncover valuable insights.

# CONCLUSION

### INSIGHTS
 - Top-paying data analyst roles are often senior-level and frequently require expertise in cloud platforms, AI tools, or data engineering.

 - High-paying roles commonly require skills like Python, SQL, Tableau, AWS, and Snowflake, blending analytics with technical depth.

- Most in-demand skills include SQL, Excel, and Python, confirming their status as foundational tools for analysts.
- Top-paying skills such as Solidity, Couchbase, and Datarobot are more niche, suggesting high reward for specialization.

- The most optimal skills to learn strike a balance between high salary and demand — such as Python, R, Tableau, Snowflake, and Looker.

### CLOSING THOUGHTS
This project gave me a hands-on experience in using SQL to analyze real-world data and uncover meaningful insights. From identifying top-paying roles to understanding which skills are most valued, I gained a clearer view of the data analyst job market in 2023.

More importantly, I learned how to break down complex questions, write structured queries, and extract insights that could guide real career decisions. I'm excited to keep building on this foundation and continue exploring data through future projects.