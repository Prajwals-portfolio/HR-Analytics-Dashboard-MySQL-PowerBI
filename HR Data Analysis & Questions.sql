
-- Questions

-- 1. What is the gender breakdown of employees in the company?

		SELECT 
    gender, COUNT(*) AS gender_count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of the employees in the company?

SELECT 
    race, COUNT(*) AS race_count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY race
ORDER BY race_count DESC;

-- 3. What is the age distribution of employees in the company?

SELECT 
    CASE
        WHEN age >= 18 AND age <= 24 THEN 'under_25'
        WHEN age >= 25 AND age <= 34 THEN 'under_35'
        WHEN age >= 35 AND age <= 44 THEN 'under_45'
        WHEN age >= 45 AND age <= 54 THEN 'under_55'
        WHEN age >= 55 AND age <= 64 THEN 'under_65'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY age_group
ORDER BY count DESC;

SELECT 
    CASE
        WHEN age >= 18 AND age <= 24 THEN 'under_25'
        WHEN age >= 25 AND age <= 34 THEN 'under_35'
        WHEN age >= 35 AND age <= 44 THEN 'under_45'
        WHEN age >= 45 AND age <= 54 THEN 'under_55'
        WHEN age >= 55 AND age <= 64 THEN 'under_65'
        ELSE '65+'
    END AS age_group,
    gender,
    COUNT(*) AS count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY age_group , gender
ORDER BY age_group , gender;

-- 4. How many employees work at headquarters versus remote locations?

SELECT 
    location, COUNT(*) AS count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY location
ORDER BY count DESC;

-- 5. What is the average length of employement for employees who have been terminated?

SELECT 
    ROUND(AVG(DATEDIFF(termdate, hire_date) / 365),
            0) AS avg_employement_duration
FROM
    human_resources
WHERE
    termdate != '0000-00-00'
        AND termdate <= CURDATE();

-- 6. How does the gender distribution vary across the departments and jobtitles?

SELECT 
    department, gender, COUNT(*) AS count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY department , gender
ORDER BY department;

SELECT 
    jobtitle, gender, COUNT(*) AS count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY jobtitle , gender
ORDER BY jobtitle;

-- 7. What is the distribution of jobtitles across the company?

SELECT 
    jobtitle, COUNT(*) AS count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?

SELECT 
    department,
    total_count,
    terminated_count,
    terminated_count / total_count AS termination_rate
FROM
    (SELECT 
        department,
            COUNT(*) AS total_count,
            SUM(CASE
                WHEN
                    termdate != '0000-00-00'
                        AND termdate <= CURDATE()
                THEN
                    1
                ELSE 0
            END) AS terminated_count
    FROM
        human_resources
    GROUP BY department) subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across loactions by city and state?

SELECT 
    location_state, COUNT(*) AS count
FROM
    human_resources
WHERE
    termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC; 

-- 10. How has the company's employee count changed over time based on hire and term dates?

SELECT 
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((((hires - terminations) / hires) * 100), 2) AS net_change_percent
FROM
    (SELECT 
        YEAR(hire_date) AS year,
            COUNT(*) AS hires,
            SUM(CASE
                WHEN
                    termdate != '0000-00-00'
                        AND termdate <= CURDATE()
                THEN
                    1
                ELSE 0
            END) AS terminations
    FROM
        human_resources
    GROUP BY year) subquery
ORDER BY year;

-- 11. What is the tenure distribution fro each department?

SELECT 
    department,
    ROUND(avg(DATEDIFF(termdate, hire_date) / 365), 0) AS avg_tenure
FROM
    human_resources
WHERE
    termdate != '0000-00-00'
        AND termdate <= CURDATE()
GROUP BY department;