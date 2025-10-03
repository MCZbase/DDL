
  CREATE OR REPLACE EDITIONABLE TRIGGER "IDENTIFICATION_CT_CHECK" 
BEFORE UPDATE OR INSERT ON IDENTIFICATION
FOR EACH ROW
DECLARE numrows NUMBER;
BEGIN
        SELECT COUNT(*) INTO numrows 
        FROM ctnature_of_id 
        WHERE nature_of_id = :NEW.nature_of_id;
        
        IF (numrows = 0) THEN
                raise_application_error(
                    -20001,
                    'Invalid nature_of_id');
        END IF;
END;


ALTER TRIGGER "IDENTIFICATION_CT_CHECK" ENABLE