
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_BUG_NUM" 
BEFORE INSERT OR UPDATE ON CF_BUGS
FOR EACH ROW
DECLARE
    iCounter CF_BUGS.BUG_ID%TYPE;
    cannot_change_counter EXCEPTION;
BEGIN
    IF INSERTING THEN
        SELECT SEQ_BUG_ID.NEXTVAL INTO iCounter FROM Dual;
        :NEW.BUG_ID := iCounter;
    END IF;
    IF UPDATING THEN
        IF NOT (:NEW.BUG_ID = :OLD.BUG_ID) THEN
            RAISE cannot_change_counter;
        END IF;
    END IF;
EXCEPTION
     WHEN cannot_change_counter THEN
         RAISE_APPLICATION_ERROR(-20000, 'Cannot Change Counter Value');
END;




ALTER TRIGGER "TRG_BUG_NUM" ENABLE