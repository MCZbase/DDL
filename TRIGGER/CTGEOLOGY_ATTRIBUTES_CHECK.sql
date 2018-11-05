
  CREATE OR REPLACE TRIGGER "CTGEOLOGY_ATTRIBUTES_CHECK" 
BEFORE UPDATE or DELETE ON geology_attribute_hierarchy
    FOR EACH ROW
    declare
    pragma autonomous_transaction;
    numrows number:=0;
    BEGIN
        SELECT COUNT(*) INTO numrows FROM geology_attribute_hierarchy WHERE attribute=:OLD.attribute
        AND GEOLOGY_ATTRIBUTE_HIERARCHY_ID != :OLD.GEOLOGY_ATTRIBUTE_HIERARCHY_ID;
        dbms_output.put_line(numrows);
        -- we only care about deleting the LAST value from the code table
        IF numrows=0 THEN
            IF updating THEN
                IF :OLD.attribute != :NEW.attribute OR (:OLD.usable_value_fg=1 AND :NEW.usable_value_fg=0) THEN
                    SELECT COUNT(*) INTO numrows FROM geology_attributes WHERE geology_attribute = :OLD.attribute;
                END IF;
            ELSE
                SELECT COUNT(*) INTO numrows FROM geology_attributes WHERE geology_attribute = :OLD.attribute;
            END IF;
            IF numrows > 0 THEN
            	 raise_application_error(
                    -20001,
                    'Cannot update or delete used geology_attribute.'
                  );
            END IF;
        END IF;
        COMMIT;

END;

ALTER TRIGGER "CTGEOLOGY_ATTRIBUTES_CHECK" ENABLE