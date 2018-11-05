
  CREATE OR REPLACE TRIGGER "TR_OBJECT_CONDITION_AIU_SQ" AFTER UPDATE OR INSERT ON coll_object
FOR EACH ROW
DECLARE
    usrid NUMBER;
    cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO cnt
    FROM agent_name
    WHERE agent_name_type = 'login'
    AND upper(agent_name.agent_name) = SYS_CONTEXT('USERENV','SESSION_USER');
    IF cnt=1 THEN
        SELECT agent_id INTO usrid
        FROM agent_name
        WHERE agent_name_type = 'login'
        AND upper(agent_name.agent_name) = SYS_CONTEXT('USERENV','SESSION_USER');
    ELSE
        usrid:=0;
    END IF;
    IF inserting THEN
        INSERT INTO object_condition (
            OBJECT_CONDITION_ID,
            COLLECTION_OBJECT_ID,
            CONDITION,
            DETERMINED_AGENT_ID,
            DETERMINED_DATE)
        VALUES(
            sq_object_condition_id.nextval,
            :NEW.COLLECTION_OBJECT_ID,
            :NEW.CONDITION,
            usrid,
            SYSDATE);
    ELSIF updating THEN
        IF :new.condition != :old.condition THEN
            INSERT INTO object_condition (
                OBJECT_CONDITION_ID,
                COLLECTION_OBJECT_ID,
                CONDITION,
                DETERMINED_AGENT_ID,
                DETERMINED_DATE)
            VALUES(
                sq_object_condition_id.nextval,
                :NEW.COLLECTION_OBJECT_ID,
                :NEW.CONDITION,
                usrid,
                SYSDATE);
        END IF;
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- just ignore
END;

ALTER TRIGGER "TR_OBJECT_CONDITION_AIU_SQ" ENABLE