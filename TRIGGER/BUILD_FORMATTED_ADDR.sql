
  CREATE OR REPLACE EDITIONABLE TRIGGER "BUILD_FORMATTED_ADDR" 
    BEFORE UPDATE OR INSERT ON addr
    FOR EACH ROW
    DECLARE
        fa addr.formatted_addr%TYPE;
		t addr%ROWTYPE;
		pName agent_name.agent_name%TYPE;
    BEGIN
        SELECT agent_name INTO pName 
        FROM preferred_agent_name 
        WHERE agent_id=:NEW.agent_id;
        fa := pName;
        IF :NEW.job_title IS NOT NULL THEN
            fa := fa || ', ' || :NEW.job_title;
        END IF;
        fa := fa || chr(10);
        IF :NEW.institution IS NOT NULL THEN
            fa := fa || :NEW.institution || chr(10);
        END IF;
        IF :NEW.department IS NOT NULL THEN
            fa := fa || :NEW.department || chr(10);
        END IF;
    	IF :NEW.street_addr1 IS NOT NULL THEN
            fa := fa || :NEW.street_addr1 || chr(10);
        END IF;
		IF :NEW.street_addr2 IS NOT NULL THEN
            fa := fa || :NEW.street_addr2 || chr(10);
        END IF;
        fa := fa || :NEW.city;
    	IF :NEW.state IS NOT NULL THEN
            fa := fa || ', ' || :NEW.state;
        END IF;
        IF :NEW.zip IS NOT NULL THEN
            fa := fa || ' ' || :NEW.zip;
        END IF;
            fa := fa || chr(10);
        IF :NEW.country_cde IS NOT NULL THEN
            fa := fa|| :NEW.country_cde || chr(10);
        END IF;
        IF :NEW.mail_stop IS NOT NULL THEN
            fa := fa|| :NEW.mail_stop;
        END IF;
        :NEW.formatted_addr := fa;	
    END;


ALTER TRIGGER "BUILD_FORMATTED_ADDR" ENABLE