SELECT res_month, vac_month
FROM
(SELECT 
    EXTRACT (MONTH FROM creation_time) AS res_month,
    COUNT(resume_id) AS res_count
FROM resume
GROUP BY res_month
ORDER BY res_count DESC LIMIT 1
) AS resume_count
FULL OUTER JOIN
(SELECT 
    EXTRACT (MONTH FROM creation_time) AS vac_month,
    COUNT(vacancy_id) AS vac_count
FROM vacancy
GROUP BY vac_month
ORDER BY vac_count DESC LIMIT 1
) AS vacancy_count
ON true;