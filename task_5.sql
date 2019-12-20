SELECT name
FROM vacancy_body
WHERE EXISTS (
    SELECT vacancy_id FROM response
    WHERE
    ((SELECT COUNT(vacancy.vacancy_id) FROM vacancy
    INNER JOIN response
    ON vacancy.vacancy_id = response.vacancy_id
    AND vacancy_body.vacancy_body_id = vacancy.vacancy_body_id
    AND (response.response_time - vacancy.creation_time) <= '7 days'::interval
    GROUP BY vacancy.vacancy_id)) < 5)
OR NOT EXISTS (
    SELECT response.vacancy_id FROM response
    INNER JOIN vacancy
    ON vacancy.vacancy_body_id = vacancy_body.vacancy_body_id
)
ORDER BY name;