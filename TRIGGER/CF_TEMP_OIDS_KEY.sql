
  CREATE OR REPLACE EDITIONABLE TRIGGER "CF_TEMP_OIDS_KEY" 
 before insert  ON cf_temp_oids
 for each row
    begin
    	if :NEW.key is null then
    		select somerandomsequence.nextval into :new.key from dual;
    	end if;
    end;


ALTER TRIGGER "CF_TEMP_OIDS_KEY" ENABLE