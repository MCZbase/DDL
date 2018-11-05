
  CREATE OR REPLACE TRIGGER "TR_ADDR_SQ" 
BEFORE INSERT ON addr
FOR EACH ROW
BEGIN
    IF :new.addr_id IS NULL THEN
        SELECT sq_addr_id.nextval
        INTO :new.addr_id
        FROM dual;
    END IF;
END;

ALTER TRIGGER "TR_ADDR_SQ" ENABLE