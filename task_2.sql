INSERT INTO vacancy_body(
    company_name, name, text, area_id, address_id, work_experience, 
    compensation_from, compensation_to, test_solution_required,
    work_schedule_type, employment_type, compensation_gross
)
SELECT 
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 150 + i % 10)::integer)) AS company_name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 220 + i % 10)::integer)) AS name,

    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 250 + i % 10)::integer)) AS text,

    (random() * 1000)::int AS area_id,
    (random() * 50000)::int AS address_id,
    (random() * 60)::integer AS work_experience,
    CASE WHEN random() < 0.5 THEN 25000 + (random() * 15000)::int ELSE 0 END AS compensation_from,
    CASE WHEN random() > 0.5 THEN 25000 + (random() * 150000)::int ELSE 0 END AS compensation_to,
    (random() > 0.5) AS test_solution_required,
    (random() * 4)::int AS work_schedule_type,
    (random() * 4)::int AS employment_type,
    (random() > 0.5) AS compensation_gross
FROM generate_series(1, 10000) AS g(i);

INSERT INTO vacancy (creation_time, expire_time, employer_id, disabled, visible, vacancy_body_id, area_id)
SELECT
    -- random in last 5 years
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS expire_time,
    (random() * 1000000)::int AS employer_id,
    (random() > 0.8) AS disabled,
    (random() > 0.5) AS visible,
    floor(random() * (10000-1+1))+1::int AS vacancy_body_id,
    (random() * 1000)::integer AS area_id
FROM generate_series(1, 10000) AS g(i);

-- Delete invalid records of vacancies and update corresponding sequencies
DELETE FROM vacancy WHERE expire_time <= creation_time;
ALTER SEQUENCE vacancy_vacancy_id_seq RESTART WITH 1;
UPDATE vacancy SET vacancy_id = nextval('vacancy_vacancy_id_seq');

INSERT INTO resume_body (desired_position, work_schedule_type, employment_type, 
    salary, education, work_experience, key_skills, language_knowledge)
SELECT
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 90 + i % 10)::integer)) AS desired_position,
    (random() * 4)::integer AS work_schedule_type,
    (random() * 5)::integer AS employment_type,
    CASE WHEN random() < 0.5 THEN 25000 + (random() * 15000)::int ELSE 0 END AS salary,
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 300 + i % 10)::integer)) AS education,
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 300 + i % 10)::integer)) AS work_experience,
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 100 + i % 10)::integer)) AS key_skills,
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 500 + i % 10)::integer)) AS language_knowledge
FROM generate_series(1, 100000) AS g(i);

INSERT INTO resume (creation_time, expire_time, full_name, 
    gender, date_of_birth, phone_number, email, visible, resume_body_id)
SELECT
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS expire_time,
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 200 + i % 10)::integer)) AS full_name,
    CASE WHEN random() > 0.5 THEN 'MALE'
    ELSE 'FEMALE' END AS gender,
    CASE WHEN random() > 0.5 THEN '01/01/2000'::date
    ELSE '01/01/1950'::date + ('1 year'::interval * floor(random() * 120)) END AS date_of_birth,
    (SELECT string_agg(
        substr(
            '0123456789', 
            (random() * 10)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 10 + i % 10)::integer)) AS phone_number,
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 90 + i % 10)::integer)) AS email,
    (random() > 0.2) AS visible,
    floor(random() * (100000-1+1))+1::int AS resume_body_id
FROM generate_series(1, 100000) AS g(i);

INSERT INTO response (vacancy_id, resume_id, response_time)
SELECT DISTINCT q.vacancy_id, q.resume_id, q.response_time
FROM
(SELECT DISTINCT
    floor(random() * (10000-1+1))+1 AS vacancy_id,
    floor(random() * (100000-1+1))+1 AS resume_id,
    now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS response_time
FROM generate_series(1, 50000) AS g(i)) AS q
WHERE q.vacancy_id
IN (SELECT vacancy_id FROM vacancy);

-- Delete invalid records in response table
DELETE FROM response WHERE response_time <= (SELECT creation_time FROM vacancy WHERE vacancy.vacancy_id = response.vacancy_id);

INSERT INTO specialization (specialization_title)
SELECT
    (SELECT string_agg(
        substr(
            '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
            (random() * 77)::integer + 1, 1
        ), 
        '') 
    FROM generate_series(1, 1 + (random() * 40 + i % 10)::integer)) AS specialization_title
FROM generate_series(1, 100) AS g(i);

INSERT INTO vacancy_body_specialization (vacancy_body_id, specialization_id)
SELECT DISTINCT
    floor(random() * (10000-1+1))+1 AS vacancy_body_id,
    floor(random() * (100-1+1))+1 AS specialization_id
FROM generate_series(1, 4000) AS g(i);

INSERT INTO resume_specialization (specialization_id, resume_id)
SELECT DISTINCT
    floor(random() * (100-1+1))+1 AS specialization_id, 
    floor(random() * (100000-1+1))+1 AS resume_id
FROM generate_series(1, 100000) AS g(i);