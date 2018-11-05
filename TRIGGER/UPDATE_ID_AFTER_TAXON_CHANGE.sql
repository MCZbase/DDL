
  CREATE OR REPLACE TRIGGER "UPDATE_ID_AFTER_TAXON_CHANGE" 
AFTER UPDATE ON TAXONOMY
FOR EACH ROW
DECLARE r VARCHAR2(4000);
BEGIN
    IF :new.scientific_name != :OLD.scientific_name THEN
        UPDATE identification SET
            scientific_name = replace(scientific_name,
                :OLD.scientific_name,:NEW.scientific_name)
        WHERE identification_id IN (
            SELECT identification_id 
            FROM identification_taxonomy 
            WHERE taxon_name_id = :NEW.taxon_name_id);
    END IF;
END;
ALTER TRIGGER "UPDATE_ID_AFTER_TAXON_CHANGE" ENABLE