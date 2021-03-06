
  CREATE OR REPLACE TRIGGER "TR_GEOGAUTHREC_AU_FLAT" 
AFTER UPDATE ON geog_auth_rec
FOR EACH ROW
BEGIN
UPDATE flat
SET stale_flag = 1,
lastuser=sys_context('USERENV', 'SESSION_USER'),
lastdate=SYSDATE
    WHERE geog_auth_rec_id = :NEW.geog_auth_rec_id;
END;

ALTER TRIGGER "TR_GEOGAUTHREC_AU_FLAT" ENABLE