SELECT required_info.name
FROM
(SELECT name, v.vacancy_id, SUM(
CASE WHEN r.vacancy_id IS NULL THEN 0
	ELSE 1 END) AS sum_response
FROM vacancy_body AS vb
INNER JOIN vacancy AS v
ON v.vacancy_body_id = vb.vacancy_body_id
LEFT JOIN response AS r
ON v.vacancy_id = r.vacancy_id
WHERE (r.vacancy_id IS NULL) OR ((r.response_time - v.creation_time) <= '7 days'::interval)
GROUP BY v.vacancy_id, name) AS required_info
WHERE required_info.sum_response < 5
GROUP BY required_info.name
ORDER BY required_info.name;