SELECT 
(SELECT 
    EXTRACT (MONTH FROM creation_time) AS res_month
FROM resume
GROUP BY res_month
ORDER BY COUNT(resume_id) DESC LIMIT 1
) AS resume_count,
(SELECT 
    EXTRACT (MONTH FROM creation_time) AS vac_month
FROM vacancy
GROUP BY vac_month
ORDER BY COUNT(vacancy_id) DESC LIMIT 1
) AS vacancy_count;