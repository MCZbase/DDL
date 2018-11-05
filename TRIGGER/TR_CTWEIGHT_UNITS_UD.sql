
  CREATE OR REPLACE TRIGGER "TR_CTWEIGHT_UNITS_UD" 
BEFORE UPDATE OR DELETE ON CTWEIGHT_UNITS
FOR EACH ROW
BEGIN
    FOR r IN (SELECT COUNT(*) c FROM attributes
                 WHERE
                 attribute_type LIKE '%weight' AND
                 attribute_units=:OLD.WEIGHT_UNITS) LOOP
        IF r.c > 0 THEN
             raise_application_error(
        -20001,
        :OLD.WEIGHT_UNITS || ' is used in attribute units');
        END IF;
    END LOOP;
END;

ALTER TRIGGER "TR_CTWEIGHT_UNITS_UD" ENABLE