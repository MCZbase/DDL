
  CREATE OR REPLACE TRIGGER "TR_BIR_CREATED_BY" 
BEFORE INSERT ON BIOL_INDIV_RELATIONS
FOR EACH ROW
BEGIN
 :NEW.CREATED_BY := SYS_CONTEXT('USERENV','SESSION_USER');
END;
ALTER TRIGGER "TR_BIR_CREATED_BY" ENABLE