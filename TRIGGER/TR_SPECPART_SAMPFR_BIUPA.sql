
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_SPECPART_SAMPFR_BIUPA" 
BEFORE INSERT OR UPDATE ON specimen_part
FOR EACH ROW
DECLARE
    numrows NUMBER;
    PRAGMA autonomous_transaction;
BEGIN
    SELECT COUNT(*) INTO numrows
    FROM specimen_part
    WHERE collection_object_id = :new.sampled_from_obj_id
    AND sampled_from_obj_id IS NOT NULL;
    IF numrows > 0 THEN
        raise_application_error(
            -20001,
            'You may not sample from a subsample.');
    END IF;
END;


ALTER TRIGGER "TR_SPECPART_SAMPFR_BIUPA" ENABLE