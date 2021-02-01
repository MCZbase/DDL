
  CREATE OR REPLACE TRIGGER "LAT_LONG_VERIFIEDBY_CHECK" 
BEFORE UPDATE OR INSERT ON LAT_LONG
FOR EACH ROW
DECLARE numrows NUMBER;
BEGIN
	IF :NEW.VERIFICATIONSTATUS = 'verified by MCZ collection' and :NEW.verified_by_agent_id is null then
        raise_application_error(
			    -20001,
			    'Verification Status "verified by MCZ collection requires a Verified by agent');
    END IF;
END;
ALTER TRIGGER "LAT_LONG_VERIFIEDBY_CHECK" ENABLE