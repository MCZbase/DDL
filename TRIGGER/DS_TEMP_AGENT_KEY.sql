
  CREATE OR REPLACE EDITIONABLE TRIGGER "DS_TEMP_AGENT_KEY" 
 before insert  ON "DS_TEMP_AGENT"
 for each row 
    begin     
    	if :NEW.key is null then                                                                                      
    		select somerandomsequence.nextval into :new.key from dual;
    	end if;                                
    end;   


ALTER TRIGGER "DS_TEMP_AGENT_KEY" ENABLE