
  CREATE OR REPLACE TRIGGER "CHCHK_PUBLICATION_ATTRIBUTES" 
before UPDATE or INSERT ON publication_attributes
for each row
declare
numrows number;
BEGIN
IF :NEW.publication_attribute = 'journal name' THEN
    SELECT COUNT(*) INTO numrows FROM ctjournal_name WHERE journal_name = :NEW.pub_att_value;
    IF (numrows = 0) THEN
     raise_application_error(
            -20001,
            'Invalid journal_name ' || :NEW.pub_att_value
          );
    END IF;
END IF;

END;

ALTER TRIGGER "CHCHK_PUBLICATION_ATTRIBUTES" ENABLE