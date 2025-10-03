
  CREATE OR REPLACE EDITIONABLE TRIGGER "GUID_OUR_THING_ONE_NOT_NULL_TRG" 
BEFORE INSERT OR UPDATE ON MCZBASE.GUID_OUR_THING
FOR EACH ROW
DECLARE
  v_count NUMBER := 0;
BEGIN

  IF :NEW.disposition = 'exists' THEN 
      -- Count the number of non-null fields
      IF :NEW.CO_COLLECTION_OBJECT_ID IS NOT NULL THEN
        v_count := v_count + 1;
      END IF;
      IF :NEW.SP_COLLECTION_OBJECT_ID IS NOT NULL THEN
        v_count := v_count + 1;
      END IF;
      IF :NEW.TAXON_NAME_ID IS NOT NULL THEN
        v_count := v_count + 1;
      END IF;

      -- Enforce that exactly one is non-null
      IF v_count != 1 THEN
        RAISE_APPLICATION_ERROR(
          -20001,
          'Exactly one of CO_COLLECTION_OBJECT_ID, SP_COLLECTION_OBJECT_ID, or TAXON_NAME_ID must be non-null.'
        );
      END IF;

  END IF;
END;
ALTER TRIGGER "GUID_OUR_THING_ONE_NOT_NULL_TRG" ENABLE