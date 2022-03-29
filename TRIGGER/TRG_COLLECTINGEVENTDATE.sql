
  CREATE OR REPLACE TRIGGER "TRG_COLLECTINGEVENTDATE" 
BEFORE INSERT OR UPDATE ON "MCZBASE"."COLLECTING_EVENT"
FOR EACH ROW
declare status varchar2(255);
BEGIN
    status:=is_iso8601(:NEW.began_date);
    IF status != 'valid' THEN
        raise_application_error(-20001,'Began Date: ' || status);
    ELSE
        :NEW.date_began_date := to_startdate(:NEW.began_date);    
    END IF;
    status:=is_iso8601(:NEW.ended_date);
    IF status != 'valid' THEN
        raise_application_error(-20001,'Ended Date: ' || status);
    ELSE
        :NEW.date_ended_date := to_enddate(:NEW.ended_date);     
    END IF;
    IF :NEW.began_date>:NEW.ended_date THEN
        raise_application_error(-20001,'Began Date can not occur after Ended Date.');
    END IF;
END;
ALTER TRIGGER "TRG_COLLECTINGEVENTDATE" ENABLE