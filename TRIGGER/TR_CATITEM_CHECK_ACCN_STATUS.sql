
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_CATITEM_CHECK_ACCN_STATUS" 
BEFORE INSERT OR UPDATE OF ACCN_ID ON "MCZBASE"."CATALOGED_ITEM"
FOR EACH ROW
DECLARE
    v_accn_status ACCN.ACCN_STATUS%TYPE;
BEGIN
    -- Get the accession status
    SELECT ACCN_STATUS INTO v_accn_status
    FROM ACCN
    WHERE TRANSACTION_ID = :NEW.ACCN_ID;

    -- Check if status is allowed
    IF v_accn_status IN ('declined', 'pre-accession') THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Cannot assign cataloged item to accession ' || :NEW.ACCN_ID || 
            ' with status "' || v_accn_status || '". ' ||
            'Only accessions with status other than "declined" or "pre-accession" can take cataloged items.'
        );
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'Accession ID ' || :NEW.ACCN_ID || ' does not exist.'
        );
END;

ALTER TRIGGER "TR_CATITEM_CHECK_ACCN_STATUS" ENABLE