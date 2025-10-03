
  CREATE OR REPLACE EDITIONABLE FUNCTION "GETPREFERREDAGENTNAME" (aid IN varchar)
RETURN varchar
-- Given an agent_id, return the preferred name for the agent.
-- @param aid the agent_id for the agent for which to look up the preferred name.
-- @return the preferred name for the agent.
-- @see preferred_agent_name the view on agent_name filtered to just preferred names.
-- @see get_agentnameoftype to retrieve agent names of other types.
AS
   n varchar(255);
BEGIN
    SELECT  /*+ RESULT_CACHE */ agent_name INTO n FROM PREFERRED_AGENT_NAME WHERE agent_id=aid;
    RETURN n;
end;