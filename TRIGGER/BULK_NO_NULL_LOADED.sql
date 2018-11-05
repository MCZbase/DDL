
  CREATE OR REPLACE TRIGGER "BULK_NO_NULL_LOADED" 
BEFORE UPDATE OR INSERT ON BULKLOADER
FOR EACH ROW
DECLARE hasrole NUMBER;
BEGIN
    IF :NEW.loaded IS NULL THEN
    select COUNT(*) INTO hasrole
        from dba_role_privs
        where upper(grantee) = SYS_CONTEXT ('USERENV','SESSION_USER')
        and upper(granted_role) = 'MANAGE_COLLECTION';

        IF hasrole = 0 THEN
            raise_application_error(
                -20001,
                'You do not have permission to set loaded to NULL.');
        END IF;
    END IF;
END;

ALTER TRIGGER "BULK_NO_NULL_LOADED" ENABLE