SELECT area_id,
    avg (
        CASE WHEN compensation_gross = true AND compensation_from IS NOT NULL
        THEN compensation_from * 0.87
        WHEN compensation_gross = false AND compensation_from IS NOT NULL
        THEN compensation_from
        ELSE 0 END
    ),
    avg (
        CASE WHEN compensation_gross = true AND compensation_to IS NOT NULL
        THEN compensation_to * 0.87
        WHEN compensation_gross = false AND compensation_to IS NOT NULL
        THEN compensation_to
        ELSE 0 END
    ),
    avg (
        CASE WHEN compensation_gross = true AND compensation_from IS NOT NULL AND compensation_to IS NOT NULL
        THEN (compensation_from * 0.87 + compensation_to * 0.87) / 2
        WHEN compensation_gross = false AND compensation_from IS NOT NULL AND compensation_to IS NOT NULL
        THEN (compensation_from + compensation_to) / 2
        ELSE 0 END
    )
FROM vacancy_body 
GROUP BY area_id 
ORDER BY area_id;