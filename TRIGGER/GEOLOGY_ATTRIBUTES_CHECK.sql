
  CREATE OR REPLACE EDITIONABLE TRIGGER "GEOLOGY_ATTRIBUTES_CHECK" 
before UPDATE or INSERT ON geology_attributes
for each row
declare
numrows number;
BEGIN
SELECT COUNT(*) INTO numrows FROM geology_attribute_hierarchy WHERE attribute = :NEW.geology_attribute;
        IF (numrows = 0) THEN
                 raise_application_error(
                -20001,
                'Invalid geology_attribute'
              );
        END IF;
END;


ALTER TRIGGER "GEOLOGY_ATTRIBUTES_CHECK" ENABLE