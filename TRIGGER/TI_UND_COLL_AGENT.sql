
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_UND_COLL_AGENT" BEFORE INSERT ON MCZBASE.UNDERSCORE_COLLECTION_AGENT for each row
BEGIN
   if inserting then 
      if :NEW.underscore_coll_agent_id is null then 
         select SEQ_UND_COLL_AGENT_ID.nextval into :NEW.underscore_coll_agent_id from dual; 
      end if; 

      if :NEW.CREATED_BY_AGENT_ID is null then
         select agent_name.agent_id
         into :NEW.CREATED_BY_AGENT_ID
         from agent_name
         where agent_name_type='login'
         and upper(agent_name.agent_name) = SYS_CONTEXT('USERENV','SESSION_USER');
         select 0 into :NEW.CREATED_BY_AGENT_ID from dual;
      end if; 
   end if; 
END;

ALTER TRIGGER "TI_UND_COLL_AGENT" ENABLE