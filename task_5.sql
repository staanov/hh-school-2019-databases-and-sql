SELECT vb.name
FROM 
(SELECT v.vacancy_id, v.vacancy_body_id, SUM(
CASE WHEN r.vacancy_id IS NULL THEN 0
	ELSE 1 END) AS sum_response
FROM vacancy AS v
LEFT JOIN response AS r
ON v.vacancy_id = r.vacancy_id
WHERE (r.vacancy_id IS NULL) OR ((r.response_time - v.creation_time) <= '7 days'::interval)
GROUP BY v.vacancy_id, v.vacancy_body_id) AS required_info
INNER JOIN vacancy_body AS vb
ON required_info.vacancy_body_id = vb.vacancy_body_id
WHERE sum_response < 5
GROUP BY vb.vacancy_body_id, vb.name
ORDER BY vb.name;