
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_REDIRECT_SQ" 
BEFORE INSERT ON redirect
FOR EACH ROW
BEGIN
    IF :new.redirect_id IS NULL THEN
        SELECT sq_redirect_id.nextval
        INTO :new.redirect_id
        FROM dual;
    END IF;
END;


ALTER TRIGGER "TR_REDIRECT_SQ" ENABLE