CREATE TABLE specialization (
    specialization_id serial PRIMARY KEY,
    specialization_title varchar(50)
);

CREATE TABLE vacancy_body (
    vacancy_body_id serial PRIMARY KEY,
    company_name varchar(150) DEFAULT ''::varchar NOT NULL,
    name varchar(220) DEFAULT ''::varchar NOT NULL,
    text text,
    area_id integer,
    address_id integer,
    work_experience integer DEFAULT 0 NOT NULL,
    compensation_from bigint DEFAULT 0,
    compensation_to bigint DEFAULT 0,
    test_solution_required boolean DEFAULT false NOT NULL,
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    compensation_gross boolean,
    driver_license_types varchar(5)[],
    CONSTRAINT vacancy_body_work_employment_type_validate CHECK ((employment_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
    CONSTRAINT vacancy_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4])))
);

CREATE TABLE vacancy (
    vacancy_id serial PRIMARY KEY,
    creation_time timestamp NOT NULL,
    expire_time timestamp NOT NULL,
    employer_id integer DEFAULT 0 NOT NULL,    
    disabled boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    vacancy_body_id serial,
    area_id integer,
    FOREIGN KEY (vacancy_body_id) REFERENCES vacancy_body(vacancy_body_id)
);

CREATE TABLE vacancy_body_specialization (
    vacancy_body_specialization_id serial PRIMARY KEY,
    vacancy_body_id integer DEFAULT 0 NOT NULL,
    specialization_id integer DEFAULT 0 NOT NULL,
    FOREIGN KEY (vacancy_body_id) REFERENCES vacancy_body(vacancy_body_id),
    FOREIGN KEY (specialization_id) REFERENCES specialization(specialization_id)
);

CREATE TABLE cv_body (
    cv_body_id serial PRIMARY KEY,
    desired_position varchar(100),
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    compensation_from bigint,
    compensation_to bigint,
    education text,
    work_experience text,
    key_skills text,
    language_knowledge text
);

CREATE TABLE cv (
    cv_id serial PRIMARY KEY,
    creation_time timestamp NOT NULL,
    expire_time timestamp NOT NULL,
    full_name varchar(200) DEFAULT ''::varchar NOT NULL,
    gender varchar(6) NOT NULL,
    date_of_birth date NOT NULL,
    city varchar(100) NOT NULL,
    phone_number varchar(20) NOT NULL,
    email varchar(100) NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    cv_body_id serial,
    area_id integer,
    FOREIGN KEY (cv_body_id) REFERENCES cv_body(cv_body_id)
);

CREATE TABLE cv_specialization (
    specialization_id serial NOT NULL,
    cv_id serial NOT NULL,
    PRIMARY KEY (specialization_id, cv_id),
    FOREIGN KEY (specialization_id) REFERENCES specialization(specialization_id),
    FOREIGN KEY (cv_id) REFERENCES cv(cv_id)
);

CREATE TABLE response (
    vacancy_id serial NOT NULL,
    cv_id serial NOT NULL,
    PRIMARY KEY (vacancy_id, cv_id),
    FOREIGN KEY (vacancy_id) REFERENCES vacancy(vacancy_id),
    FOREIGN KEY (cv_id) REFERENCES cv(cv_id)
);
