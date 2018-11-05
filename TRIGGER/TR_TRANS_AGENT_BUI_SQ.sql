
  CREATE OR REPLACE TRIGGER "TR_TRANS_AGENT_BUI_SQ" 
BEFORE UPDATE OR INSERT ON TRANS_AGENT
FOR EACH ROW
DECLARE numrows NUMBER;
BEGIN
    IF :new.trans_agent_id IS NULL THEN
    SELECT sq_trans_agent_id.NEXTVAL
INTO :new.trans_agent_id
FROM dual;
    END IF;

    SELECT COUNT(*) INTO numrows
FROM cttrans_agent_role
WHERE trans_agent_role = :new.trans_agent_role;

IF (numrows = 0) THEN
    raise_application_error(
-20001,
'Invalid trans_agent_role');
    END IF;
END;

ALTER TRIGGER "TR_TRANS_AGENT_BUI_SQ" ENABLE