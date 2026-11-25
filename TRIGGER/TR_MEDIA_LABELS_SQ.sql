
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_MEDIA_LABELS_SQ" 
BEFORE INSERT ON "MCZBASE"."MEDIA_LABELS"
FOR EACH ROW
BEGIN
        IF :NEW.media_label_id IS NULL THEN
                SELECT "MCZBASE"."SQ_MEDIA_LABEL_ID".NEXTVAL
                INTO :NEW.media_label_id
                FROM dual;
        END IF;

        -- The person adding the label: the session's database user, matched to an agent's login
        -- name; agent 0 only when none matches.
        IF :NEW.assigned_by_agent_id IS NULL THEN
                BEGIN
                        SELECT agent_name.agent_id
                        INTO :NEW.assigned_by_agent_id
                        FROM "MCZBASE"."AGENT_NAME" agent_name
                        WHERE agent_name.agent_name_type = 'login'
                                AND UPPER(agent_name.agent_name) = SYS_CONTEXT('USERENV', 'SESSION_USER')
                                AND ROWNUM = 1;
                EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                                :NEW.assigned_by_agent_id := 0;
                END;
        END IF;
END;

ALTER TRIGGER "TR_MEDIA_LABELS_SQ" ENABLE