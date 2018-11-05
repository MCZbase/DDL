
  CREATE OR REPLACE TRIGGER "TR_AGENTNAME_AIU_FLAT" 
AFTER INSERT OR UPDATE ON agent_name
FOR EACH ROW
BEGIN
IF :NEW.agent_name_type = 'preferred' THEN
    FOR r IN (
            SELECT collection_object_id
            FROM collector
            WHERE agent_id = :NEW.agent_id
        ) LOOP
        UPDATE flat
        SET stale_flag = 1,
        lastuser=sys_context('USERENV', 'SESSION_USER'),
        lastdate=SYSDATE
        WHERE collection_object_id = r.collection_object_id;
    END LOOP;
END IF;
END;

ALTER TRIGGER "TR_AGENTNAME_AIU_FLAT" ENABLE