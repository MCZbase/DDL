
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_CTLENGTH_UNITS_UD" 
BEFORE UPDATE OR DELETE ON ctlength_units
FOR EACH ROW
BEGIN
    FOR r IN (SELECT COUNT(*) c FROM attributes
                 WHERE
                 attribute_type LIKE '% length' AND
                 attribute_units=:OLD.length_units) LOOP
        IF r.c > 0 THEN
             raise_application_error(
        -20001,
        :OLD.length_units || ' is used in attribute units');
        END IF;
    END LOOP;
END;


ALTER TRIGGER "TRG_CTLENGTH_UNITS_UD" ENABLE