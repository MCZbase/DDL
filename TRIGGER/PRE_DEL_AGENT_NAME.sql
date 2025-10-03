
  CREATE OR REPLACE EDITIONABLE TRIGGER "PRE_DEL_AGENT_NAME" before DELETE or UPDATE on agent_name for each row
-- DLM 1 Mar 2006
-- require preferred agent name
declare numrows INTEGER;
begin

	-- clear out the staging table
	DELETE FROM agent_name_pending_delete;
	-- grab the info they're trying to modify
  	INSERT INTO  agent_name_pending_delete (
  		AGENT_NAME_ID,
	  	AGENT_ID,
	  	AGENT_NAME_TYPE,
	  	AGENT_NAME
	) VALUES (
		:old.AGENT_NAME_ID,
		:old.AGENT_ID,
		:old.AGENT_NAME_TYPE,
		:old.AGENT_NAME);


-- ERwin Builtin Wed May 05 11:26:47 2004
end;


ALTER TRIGGER "PRE_DEL_AGENT_NAME" ENABLE