
  CREATE OR REPLACE TRIGGER "TRG_CTNUMERIC_AGE_UNITS_UD" 
BEFORE UPDATE OR DELETE ON CTNUMERIC_AGE_UNITS
FOR EACH ROW
BEGIN
    FOR r IN (SELECT COUNT(*) c FROM attributes
                 WHERE
                 attribute_type='numeric age' AND
                 attribute_units=:OLD.NUMERIC_AGE_UNITS) LOOP
        IF r.c > 0 THEN
             raise_application_error(
        -20001,
        :OLD.NUMERIC_AGE_UNITS || ' is used in attribute units');
        END IF;
    END LOOP;
END;

ALTER TRIGGER "TRG_CTNUMERIC_AGE_UNITS_UD" ENABLE