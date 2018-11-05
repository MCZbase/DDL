
  CREATE OR REPLACE TRIGGER "CF_LOG_ID" 
 before insert  ON cf_log
 for each row
    begin
    	if :NEW.log_id is null then
    		select somerandomsequence.nextval into :new.log_id from dual;
    	end if;
		if :NEW.access_date is null then
    		:NEW.access_date:= sysdate;
    	end if;
    end;


ALTER TRIGGER "CF_LOG_ID" ENABLE