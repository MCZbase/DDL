
  CREATE OR REPLACE TRIGGER "TR_SPECPARTATT_AIUD_FLAT" 
AFTER INSERT OR UPDATE OR DELETE ON SPECIMEN_PART_ATTRIBUTE
FOR EACH ROW
DECLARE id NUMBER;
BEGIN
    IF deleting THEN
        select derived_from_cat_item into id from specimen_part where collection_object_id = :OLD.collection_object_id;
    ELSE
        select derived_from_cat_item into id from specimen_part where collection_object_id = :NEW.collection_object_id;
    END IF;

    UPDATE flat SET
        stale_flag = 1,
        lastuser = sys_context('USERENV', 'SESSION_USER'),
        lastdate = SYSDATE
    WHERE collection_object_id = id;
END;
ALTER TRIGGER "TR_SPECPARTATT_AIUD_FLAT" ENABLE