
  CREATE OR REPLACE TRIGGER "IDENTIFICATION_DATE_CHECK" 
BEFORE UPDATE OR INSERT ON IDENTIFICATION
FOR EACH ROW
DECLARE numrows NUMBER;
BEGIN

If :new.made_date is not null then
    IF is_iso8601(:new.made_date) <> 'valid' then
            raise_application_error(
                -20001,
                'Invalid date format for MADE DATE');
    END IF;
End IF;
END;
ALTER TRIGGER "IDENTIFICATION_DATE_CHECK" ENABLE