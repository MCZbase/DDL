
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ACCN_AIU_FLAT" 
AFTER INSERT OR UPDATE ON accn
FOR EACH ROW
BEGIN
IF :NEW.accn_number != :OLD.accn_number THEN
    UPDATE flat
    SET stale_flag = 1,
    lastuser=sys_context('USERENV', 'SESSION_USER'),
    lastdate=SYSDATE
    WHERE accn_id = :new.transaction_id;
END IF;
END;


ALTER TRIGGER "TR_ACCN_AIU_FLAT" ENABLE