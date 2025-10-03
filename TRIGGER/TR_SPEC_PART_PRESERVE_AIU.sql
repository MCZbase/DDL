
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_SPEC_PART_PRESERVE_AIU" AFTER UPDATE OR INSERT ON specimen_part
FOR EACH ROW
DECLARE
    usrid NUMBER;
    cnt NUMBER;
    newLotCount coll_object.lot_count%type;
    newLotCountMod coll_object.lot_count_modifier%type;
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
        INSERT INTO SPECIMEN_PART_PRES_HIST (
            SPECIMEN_PART_PRES_HIST_ID,
            COLLECTION_OBJECT_ID, 
            PART_NAME, 
            SAMPLED_FROM_OBJ_ID, 
            PRESERVE_METHOD, 
            DERIVED_FROM_CAT_ITEM, 
            CHANGED_AGENT_ID,
            CHANGED_DATE,
            IS_CURRENT_FG)
        VALUES(
            SQ_SPECIMEN_PART_PRES_HIST_ID.nextval,
            :NEW.COLLECTION_OBJECT_ID,
            :NEW.PART_NAME,
            :NEW.SAMPLED_FROM_OBJ_ID, 
            :NEW.PRESERVE_METHOD,
            :NEW.DERIVED_FROM_CAT_ITEM,
            usrid,
            SYSDATE,
            1);

        ---get lot_count
        select lot_count, lot_count_modifier into newLotCount, newLotCountMod from coll_object where collection_object_id = :NEW.COLLECTION_OBJECT_ID;
        update SPECIMEN_PART_PRES_HIST set lot_count = newLotCount, lot_count_modifier = newLotCountMod where collection_object_id = :NEW.COLLECTION_OBJECT_ID;

    ELSIF updating THEN
        IF :new.PRESERVE_METHOD != :old.PRESERVE_METHOD or :new.PART_NAME != :old.PART_NAME  THEN
            update SPECIMEN_PART_PRES_HIST set is_current_FG = 0 WHERE is_current_FG = 1 AND COLLECTION_OBJECT_ID = :NEW.COLLECTION_OBJECT_ID;

            INSERT INTO SPECIMEN_PART_PRES_HIST (
            SPECIMEN_PART_PRES_HIST_ID,
            COLLECTION_OBJECT_ID, 
            PART_NAME, 
            SAMPLED_FROM_OBJ_ID, 
            PRESERVE_METHOD, 
            DERIVED_FROM_CAT_ITEM, 
            CHANGED_AGENT_ID,
            CHANGED_DATE,
            IS_CURRENT_FG)
            VALUES(
            SQ_SPECIMEN_PART_PRES_HIST_ID.nextval,
            :NEW.COLLECTION_OBJECT_ID,
            :NEW.PART_NAME,
            :NEW.SAMPLED_FROM_OBJ_ID, 
            :NEW.PRESERVE_METHOD,
            :NEW.DERIVED_FROM_CAT_ITEM,
            usrid,
            SYSDATE,
            1);
        END IF;
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- just ignore
END;

ALTER TRIGGER "TR_SPEC_PART_PRESERVE_AIU" ENABLE