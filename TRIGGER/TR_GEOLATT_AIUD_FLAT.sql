
  CREATE OR REPLACE TRIGGER "TR_GEOLATT_AIUD_FLAT" 
AFTER INSERT OR UPDATE OR DELETE ON GEOLOGY_ATTRIBUTES
FOR EACH ROW
DECLARE id NUMBER;
BEGIN
    IF deleting THEN 
        id := :OLD.locality_id;
    ELSE 
        id := :NEW.locality_id;
    END IF;
        
    UPDATE flat SET 
        stale_flag = 1,
        lastuser = sys_context('USERENV', 'SESSION_USER'),
		lastdate = SYSDATE
    WHERE locality_id = id;
END;
ALTER TRIGGER "TR_GEOLATT_AIUD_FLAT" ENABLE