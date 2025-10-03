
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_IDTAXONOMY_AIUD_FLAT" 
AFTER INSERT OR UPDATE OR DELETE ON identification_taxonomy
FOR EACH ROW
DECLARE id NUMBER;
BEGIN
    IF deleting
        THEN id := :OLD.identification_id;
    ELSE id := :NEW.identification_id;

END IF;
    UPDATE flat
    SET stale_flag = 1,
lastuser=sys_context('USERENV', 'SESSION_USER'),
lastdate=SYSDATE
WHERE identification_id = id;
END;


ALTER TRIGGER "TR_IDTAXONOMY_AIUD_FLAT" ENABLE