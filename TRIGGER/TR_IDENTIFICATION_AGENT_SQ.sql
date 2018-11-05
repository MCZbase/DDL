
  CREATE OR REPLACE TRIGGER "TR_IDENTIFICATION_AGENT_SQ" BEFORE INSERT ON identification_agent
FOR EACH ROW
BEGIN
    IF :NEW.identification_agent_id IS NULL THEN
        SELECT sq_identification_agent_id.nextval
        INTO :new.identification_agent_id FROM dual;
    END IF;
END;

ALTER TRIGGER "TR_IDENTIFICATION_AGENT_SQ" ENABLE