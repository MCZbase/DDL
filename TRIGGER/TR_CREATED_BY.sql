
  CREATE OR REPLACE TRIGGER "TR_CREATED_BY" 
BEFORE INSERT ON AGENT_RELATIONS 
FOR EACH ROW
BEGIN
IF SYS_CONTEXT('USERENV','SESSION_USER') = 'HELIUMCELL' then
    :NEW.CREATED_BY := 'BHALEY';
ELSE
    :NEW.CREATED_BY := SYS_CONTEXT('USERENV','SESSION_USER');
END IF;
END;
ALTER TRIGGER "TR_CREATED_BY" ENABLE