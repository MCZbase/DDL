
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ENCUMBRANCE_AIUD_FLAT" 
AFTER INSERT OR UPDATE OR DELETE ON encumbrance
FOR EACH ROW
DECLARE id NUMBER;
BEGIN
    IF deleting
        THEN id := :OLD.encumbrance_id;
        ELSE id := :NEW.encumbrance_id;
    END IF;

    UPDATE flat
    SET stale_flag = 1,
    lastuser = sys_context('USERENV', 'SESSION_USER'),
    lastdate = SYSDATE
    WHERE collection_object_id in (select collection_object_id from coll_object_encumbrance where encumbrance_id = id);
END;

ALTER TRIGGER "TR_ENCUMBRANCE_AIUD_FLAT" ENABLE