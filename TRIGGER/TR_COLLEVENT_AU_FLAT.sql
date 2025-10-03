
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_COLLEVENT_AU_FLAT" 
AFTER UPDATE ON COLLECTING_EVENT
FOR EACH ROW
BEGIN
    UPDATE flat SET 
        stale_flag = 1,
        lastuser = sys_context('USERENV', 'SESSION_USER'),
        lastdate = SYSDATE
    WHERE collecting_event_id = :NEW.collecting_event_id;
END;


ALTER TRIGGER "TR_COLLEVENT_AU_FLAT" ENABLE