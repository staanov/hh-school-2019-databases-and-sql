CREATE TABLE vacancy_body (
    vacancy_body_id serial PRIMARY KEY,
    company_name varchar(150) DEFAULT ''::varchar NOT NULL,
    title varchar(220) DEFAULT ''::varchar NOT NULL,
    content text,
    area_id integer,
    address_id integer,
    required_work_experience integer DEFAULT 0 NOT NULL,
    min_salary bigint DEFAULT 0,
    max_salary bigint DEFAULT 0,
    test_solution_required boolean DEFAULT false NOT NULL,
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    is_salary_gross boolean,
    driver_license_types varchar(5)[],
    CONSTRAINT vacancy_body_work_employment_type_validate CHECK ((employment_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
    CONSTRAINT vacancy_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4])))
);

CREATE TABLE vacancy (
    vacancy_id serial PRIMARY KEY,
    creation_time timestamp NOT NULL,
    expire_time timestamp NOT NULL,
    employer_id integer DEFAULT 0 NOT NULL,
    is_disabled boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    vacancy_body_id serial,
    area_id integer,
    FOREIGN KEY (vacancy_body_id) REFERENCES vacancy_body(vacancy_body_id)
);

CREATE TABLE vacancy_body_specialization (
    vacancy_body_specialization_id integer NOT NULL PRIMARY KEY,
    vacancy_body_id integer DEFAULT 0 NOT NULL,
    specialization_id integer DEFAULT 0 NOT NULL,
    FOREIGN KEY (vacancy_body_id) REFERENCES vacancy_body(vacancy_body_id)
);

CREATE TABLE cv_body (
    cv_body_id serial PRIMARY KEY,
    desired_position varchar(100),
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    specialization integer[],
    education text,
    work_experience text,
    key_skills text,
    language_knowledge text
);

CREATE TABLE cv (
    cv_id serial PRIMARY KEY,
    creation_time timestamp NOT NULL,
    expire_time timestamp NOT NULL,
    full_name varchar(150) DEFAULT ''::varchar NOT NULL,
    gender varchar(6) NOT NULL,
    date_of_birth date NOT NULL,
    city varchar(100) NOT NULL,
    phone_number varchar(15) NOT NULL,
    email varchar(50) NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    cv_body_id serial,
    FOREIGN KEY (cv_body_id) REFERENCES cv_body(cv_body_id)
);

CREATE TABLE specializations (
    specialization_id serial NOT NULL PRIMARY KEY,
    specialization_title varchar(20)
);

CREATE TABLE response (
    vacancy_id serial NOT NULL,
    cv_id serial NOT NULL,
    PRIMARY KEY (vacancy_id, cv_id)
);
