
  CREATE OR REPLACE TRIGGER "TR_ENCUMBRANCE_EXPIRE" 
BEFORE UPDATE OR INSERT ON encumbrance
FOR EACH ROW
BEGIN
    IF (:new.EXPIRATION_DATE IS NULL AND :new.EXPIRATION_EVENT IS NULL) OR
       (:new.EXPIRATION_DATE IS NOT NULL AND :new.EXPIRATION_EVENT IS NOT NULL) THEN
        raise_application_error(
            -20001,
            'Encumbrances must have either an expiration event or an expiration date, but may not have both.');
    END IF;
END;
ALTER TRIGGER "TR_ENCUMBRANCE_EXPIRE" ENABLE