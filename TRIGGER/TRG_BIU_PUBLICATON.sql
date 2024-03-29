
  CREATE OR REPLACE TRIGGER "TRG_BIU_PUBLICATON" 
BEFORE UPDATE OR INSERT ON "MCZBASE"."PUBLICATION"
FOR EACH ROW
BEGIN
    IF :NEW.doi is not null THEN
    	if :NEW.doi != trim(:NEW.doi) then
    		raise_application_error(
                -20001,
                'Invalid DOI: DOIs may not have leading or trailing spaces.'
            );
    	end if;

    	if lower(substr(:NEW.doi,1,3)) in ('htt','doi') then
            raise_application_error(
                -20001,
                'Invalid DOI: DOIs may not be prefixed. Use "10.1093/jmammal/12.4.432" instead of "http://dx.doi.org/10.1093/jmammal/12.4.432" or "DOI:10.1093/jmammal/12.4.432"'
            );
        END IF;
    END IF;
    :NEW.LAST_UPDATE_DATE := CURRENT_TIMESTAMP;
END;
ALTER TRIGGER "TRG_BIU_PUBLICATON" ENABLE