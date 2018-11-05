
  CREATE OR REPLACE TRIGGER "TRG_COLLECTINGEVENTDATE" 
BEFORE INSERT OR UPDATE ON collecting_event
FOR EACH ROW
declare status varchar2(255);
BEGIN
    status:=is_iso8601(:NEW.began_date);
    IF status != 'valid' THEN
        raise_application_error(-20001,'Began Date: ' || status);
    END IF;
    status:=is_iso8601(:NEW.ended_date);
    IF status != 'valid' THEN
        raise_application_error(-20001,'Ended Date: ' || status);
    END IF;
    IF :NEW.began_date>:NEW.ended_date THEN
        raise_application_error(-20001,'Began Date can not occur after Ended Date.');
    END IF;
END;

ALTER TRIGGER "TRG_COLLECTINGEVENTDATE" ENABLE