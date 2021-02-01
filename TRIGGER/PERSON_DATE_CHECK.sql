
  CREATE OR REPLACE TRIGGER "PERSON_DATE_CHECK" 
BEFORE UPDATE OR INSERT ON PERSON
FOR EACH ROW
BEGIN

If :new.birth_date is not null then
    IF is_iso8601(:new.birth_date) <> 'valid' then
            raise_application_error(
                -20001,
                'BIRTH DATE and DEATH DATE must be a valid date in the form "YYYY", "YYYY-MM", or "YYYY-MM-DD"');
    END IF;
End IF;
If :new.death_date is not null then
    IF is_iso8601(:new.death_date) <> 'valid' then
            raise_application_error(
                -20001,
                'BIRTH DATE and DEATH DATE must be a valid date in the form "YYYY", "YYYY-MM", or "YYYY-MM-DD"');
    END IF;
End IF;
END;
ALTER TRIGGER "PERSON_DATE_CHECK" ENABLE