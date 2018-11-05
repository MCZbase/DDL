
  CREATE OR REPLACE TRIGGER "TR_LOCALITY_AU_FLAT" 
AFTER UPDATE ON locality
FOR EACH ROW
BEGIN
    UPDATE flat
    SET stale_flag = 1,
lastuser=sys_context('USERENV', 'SESSION_USER'),
lastdate=SYSDATE
    WHERE locality_id = :NEW.locality_id;
END;

ALTER TRIGGER "TR_LOCALITY_AU_FLAT" ENABLE