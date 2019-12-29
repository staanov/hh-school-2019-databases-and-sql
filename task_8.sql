CREATE TABLE resume_changes (
    resume_changes_id serial PRIMARY KEY,
    resume_id integer NOT NULL,
    last_change_time timestamp NOT NULL,
    json jsonb NOT NULL,
    FOREIGN KEY (resume_id) REFERENCES resume(resume_id)
);

CREATE FUNCTION save_changes() RETURNS trigger AS $save_changes$
    BEGIN
        INSERT INTO resume_changes (resume_id, last_change_time, json)
        VALUES (OLD.resume_id, now(), to_json(old.*));
        IF NEW IS NULL THEN
            RETURN OLD;
        ELSE
            RETURN NEW;
        END IF;
    END;
$save_changes$ LANGUAGE plpgsql;

CREATE TRIGGER save_changes BEFORE UPDATE OR DELETE ON resume 
FOR EACH ROW EXECUTE FUNCTION save_changes();

SELECT
    resume_id,
    last_change_time,
    json
FROM resume_changes
ORDER BY resume_id, last_change_time;