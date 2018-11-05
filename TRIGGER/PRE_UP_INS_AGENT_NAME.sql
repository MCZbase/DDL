
  CREATE OR REPLACE TRIGGER "PRE_UP_INS_AGENT_NAME" before insert on agent_name for each row
-- DLM 1 Mar 2006
-- require ONE preferred agent name
begin
	-- clear out the staging table
	DELETE FROM agent_name_pending_delete;
	-- grab the info already in there
  	INSERT INTO  agent_name_pending_delete select
  		AGENT_NAME_ID,
	  	AGENT_ID,
	  	AGENT_NAME_TYPE,
	  	AGENT_NAME
	  	from agent_name
	  	where agent_id=:new.agent_id;
	  -- and the new one
	  INSERT INTO  agent_name_pending_delete (
  		AGENT_NAME_ID,
	  	AGENT_ID,
	  	AGENT_NAME_TYPE,
	  	AGENT_NAME
	) VALUES (
		:new.AGENT_NAME_ID,
		:new.AGENT_ID,
		:new.AGENT_NAME_TYPE,
		:new.AGENT_NAME);
end;

ALTER TRIGGER "PRE_UP_INS_AGENT_NAME" ENABLE