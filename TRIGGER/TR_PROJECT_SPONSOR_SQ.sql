
  CREATE OR REPLACE TRIGGER "TR_PROJECT_SPONSOR_SQ" before INSERT on project_sponsor
for each row
BEGIN
    if :NEW.project_sponsor_id is null then
        select sq_project_sponsor_id.nextval
        into :new.project_sponsor_id from dual;
    end if;
END;

ALTER TRIGGER "TR_PROJECT_SPONSOR_SQ" ENABLE