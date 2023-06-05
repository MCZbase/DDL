
  CREATE OR REPLACE TRIGGER "TU_UNDERSCORE_COLL_CITATION" 
BEFORE UPDATE ON MCZBASE.UNDERSCORE_COLLECTION_CITATION 
for each row
declare 
agentID agent.agent_id%type;
BEGIN
   select agent_id into agentID from agent_name where upper(agent_name) = SYS_CONTEXT('USERENV','SESSION_USER') and agent_name_type = 'login';
  :NEW.date_last_updated := current_timestamp;
  :NEW.last_updated_by_agent_id := agentID;
END;
ALTER TRIGGER "TU_UNDERSCORE_COLL_CITATION" ENABLE