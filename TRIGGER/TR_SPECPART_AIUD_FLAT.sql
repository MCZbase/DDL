
  CREATE OR REPLACE TRIGGER "TR_SPECPART_AIUD_FLAT" 
AFTER INSERT OR UPDATE OR DELETE ON SPECIMEN_PART
FOR EACH ROW
DECLARE id NUMBER;
BEGIN
    IF deleting THEN
        id := :OLD.derived_from_cat_item;
    ELSE
        id := :NEW.derived_from_cat_item;
    END IF;

    UPDATE flat SET
        stale_flag = 1,
        lastuser = sys_context('USERENV', 'SESSION_USER'),
        lastdate = SYSDATE
    WHERE collection_object_id = id;
END;

ALTER TRIGGER "TR_SPECPART_AIUD_FLAT" ENABLE