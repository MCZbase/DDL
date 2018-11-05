
  CREATE OR REPLACE TRIGGER "TR_CTJOURNAL_NAME_UD" 
BEFORE UPDATE OR DELETE ON ctjournal_name
FOR EACH ROW
BEGIN
    FOR r IN (SELECT COUNT(*) c FROM publication_attributes
                 WHERE
                 PUBLICATION_ATTRIBUTE='journal name' AND
                 PUB_ATT_VALUE=:old.journal_name) LOOP
        IF r.c > 0 THEN
             raise_application_error(
        -20001,
        :OLD.journal_name || ' is used.');
        END IF;
    END LOOP;
END;

ALTER TRIGGER "TR_CTJOURNAL_NAME_UD" ENABLE