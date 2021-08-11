
  CREATE OR REPLACE TRIGGER "TI_COMMON_NAME_ID" 
BEFORE INSERT ON MCZBASE.COMMON_NAME 
FOR EACH ROW
BEGIN
    IF :new.common_name_id IS NULL THEN
        select sq_common_name_id.nextval
        into :new.common_name_id
        from dual;
    END IF;
END;
ALTER TRIGGER "TI_COMMON_NAME_ID" ENABLE