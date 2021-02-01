
  CREATE OR REPLACE TRIGGER "TR_IDENTIFICATION_AIU_FLAT" 
AFTER INSERT OR UPDATE ON IDENTIFICATION
FOR EACH ROW
BEGIN
    IF :NEW.accepted_id_fg = 1 or nvl(:old.stored_as_fg, -1) != nvl(:new.stored_as_fg, -1) THEN
        UPDATE flat SET 
            stale_flag = 1,
            lastuser = sys_context('USERENV', 'SESSION_USER'),
            lastdate = SYSDATE
        WHERE collection_object_id = :NEW.collection_object_id;
    END IF;
END;
ALTER TRIGGER "TR_IDENTIFICATION_AIU_FLAT" ENABLE