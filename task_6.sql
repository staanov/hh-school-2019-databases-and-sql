(SELECT id_and_array.resume_id, id_and_array.spec_array, most_freq_spec.freq_spec
FROM
    (SELECT 
        resume_id,
        array_agg(specialization_id) AS spec_array
    FROM resume_specialization
    GROUP BY resume_id
    ORDER BY resume_id
    ) AS id_and_array
INNER JOIN
    (SELECT
        rs.resume_id,
        mode() WITHIN GROUP (ORDER BY vbs.specialization_id DESC) AS freq_spec
    FROM resume_specialization AS rs
    INNER JOIN
        response AS resp
    ON rs.resume_id = resp.resume_id
    INNER JOIN 
        vacancy AS vac
    ON resp.vacancy_id = vac.vacancy_id
    INNER JOIN 
        vacancy_body AS vb
    ON vac.vacancy_body_id = vb.vacancy_body_id
    INNER JOIN 
        vacancy_body_specialization AS vbs
    ON vb.vacancy_body_id = vbs.vacancy_body_id
    GROUP BY rs.resume_id
    ) AS most_freq_spec
ON id_and_array.resume_id = most_freq_spec.resume_id
ORDER BY id_and_array.resume_id)
UNION
    (SELECT
        r_s.resume_id,
        array_agg(specialization_id) AS spec_array,
        NULL
    FROM resume_specialization AS r_s
    LEFT JOIN 
        response AS respon
    ON r_s.resume_id = respon.resume_id
    WHERE respon.resume_id IS NULL
    GROUP BY r_s.resume_id
    );