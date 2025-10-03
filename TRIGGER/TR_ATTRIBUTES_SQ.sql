
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ATTRIBUTES_SQ" 
BEFORE INSERT ON attributes
FOR EACH ROW
BEGIN
    IF :new.attribute_id IS NULL THEN
        SELECT sq_attribute_id.nextval
        INTO :new.attribute_id
        FROM dual;
    END IF;
END;


ALTER TRIGGER "TR_ATTRIBUTES_SQ" ENABLE