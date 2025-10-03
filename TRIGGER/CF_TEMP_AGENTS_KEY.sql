
  CREATE OR REPLACE EDITIONABLE TRIGGER "CF_TEMP_AGENTS_KEY" 
 before insert  ON "MCZBASE"."CF_TEMP_AGENTS"
 for each row
    begin
    	if :NEW.key is null then
    		select somerandomsequence.nextval into :new.key from dual;
    	end if;
    end;



ALTER TRIGGER "CF_TEMP_AGENTS_KEY" ENABLE